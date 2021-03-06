package com.rdongol.rentcollection.service;

import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.rdongol.rentcollection.model.BillContractServiceModel;
import com.rdongol.rentcollection.model.Contract;
import com.rdongol.rentcollection.model.ContractLog;
import com.rdongol.rentcollection.model.Rentee;
import com.rdongol.rentcollection.model.Renting;
import com.rdongol.rentcollection.model.RentingFacility;
import com.rdongol.rentcollection.model.ServiceDetail;
import com.rdongol.rentcollection.model.Transaction;
import com.rdongol.rentcollection.model.TransactionDetail;
import com.rdongol.rentcollection.model.TransactionDetailModel;
import com.rdongol.rentcollection.model.TransactionServiceDetail;
import com.rdongol.rentcollection.repository.TransactionRepository;

@Service
public class TransactionService {

	@Autowired
	private TransactionRepository transactionRepository;

	@Autowired
	private ContractService contractService;

	@Autowired
	private ServiceDetailService serviceDetailService;

	@Autowired
	private RentingFacilityService rentingFacilityService;

	@Autowired
	private ContractLogService contractLogService;

	@Autowired
	private RentingService rentingService;

	@Autowired
	private RenteeService renteeService;

	public List<Transaction> findAll() {
		return (List<Transaction>) transactionRepository.findAll();
	}

	public Transaction findById(Long id) {

		Optional<Transaction> transaction = transactionRepository.findById(id);

		if (!transaction.isPresent()) {
			return null;
		}

		return transaction.get();

	}

	public Transaction save(Transaction transaction) {

		List<TransactionDetail> transactionDetails = transaction.getTransactionDetail();
		if (transactionDetails != null) {
			for (TransactionDetail transactionDetail : transactionDetails) {
				transactionDetail.setTransaction(transaction);

				List<TransactionServiceDetail> transactionServiceDetails = transactionDetail
						.getTransactionServiceDetail();

				if (transactionServiceDetails != null) {

					for (TransactionServiceDetail transactionServiceDetail : transactionServiceDetails) {
						transactionServiceDetail.setTransactionDetail(transactionDetail);
					}
				}
			}

		}

		return transactionRepository.save(transaction);

	}

	public void deleteById(Long id) {
		transactionRepository.deleteById(id);
	}

	public TransactionDetailModel getTransactionDetail(long id) {
		Transaction transaction = findById(id);

		if (transaction == null) {
			return null;

		}

		return getTransactDetail(transaction);
	}

	public TransactionDetailModel getTransactDetail(Transaction transaction) {

		ContractLog contractLog = contractLogService.getContractLogByContractId(transaction.getContractId());

		Renting renting = rentingService.findById(contractLog.getRentingId());

		Rentee rentee = renteeService.findById(contractLog.getRenteeId());

		TransactionDetailModel transactionDetailModel = new TransactionDetailModel();

		transactionDetailModel.setTransaction(transaction);
		transactionDetailModel.setRentingName(renting.getName());
		transactionDetailModel.setRenteeName(rentee.getFirstName() + " " + rentee.getLastName());
		transactionDetailModel.setAddress(rentee.getAddress());
		transactionDetailModel.setNumber(rentee.getPhoneNumber());
		return transactionDetailModel;

	}

	public TransactionDetailModel getTransactionDetail(long contractId, double numberOfMonths,
			List<BillContractServiceModel> billContractServiceModels) {

		Transaction transaction = calculateBill(contractId, numberOfMonths, billContractServiceModels);

		return getTransactDetail(transaction);
	}

	public TransactionDetailModel calculateForTermination(long contractId,
			List<BillContractServiceModel> billContractServiceModels) {

		DecimalFormat df2 = new DecimalFormat("#.##");
		Contract contract = contractService.findById(contractId);
		if (contract == null) {
			return null;
		}

		double daysDiference = (contract.getExpireDate().getTime() - new Date().getTime()) / (1000 * 60 * 60 * 24);

		double remainingDays = 30 - daysDiference;
		double daysInMonth = Double.valueOf(df2.format((Double) remainingDays / 30));

		Transaction transaction = calculateBill(contractId, daysInMonth, billContractServiceModels);
		if(transaction == null) {
			return null;
		}
		transaction.setNote("Terminate Contract");
		return getTransactDetail(transaction);

	}

	public Transaction calculateBill(long contractId, double numberOfMonths,
			List<BillContractServiceModel> billContractServiceModels) {

		Contract contract = contractService.findById(contractId);
		if (contract == null) {
			return null;
		}

		Renting renting = contract.getRenting();

		Transaction transaction = new Transaction();

		transaction.setContractId(contractId);
		transaction.setNumberOfMonths(numberOfMonths);
		transaction.setContractCharge(renting.getPrice());
		transaction.setBilledDate(new Date());
		transaction.setCharge(renting.getPrice() * numberOfMonths);
		List<TransactionDetail> transactionDetails = new LinkedList<TransactionDetail>();
		for (BillContractServiceModel billContractServiceModel : billContractServiceModels) {

			TransactionDetail transactionDetail = calculateTransactionDetail(numberOfMonths, billContractServiceModel);
			if (transactionDetail != null) {

				transactionDetails.add(transactionDetail);

			}
		}

		transaction.setTransactionDetail(transactionDetails);

		transaction.setTotalCharge(getTransactionTotal(transactionDetails, renting.getPrice() * numberOfMonths));
		transaction.setNote(getTransactionNote((int) numberOfMonths, contract.getExpireDate()));
		return transaction;
	}

	private String getTransactionNote(int numberOfMonths, Date expireDate) {

		StringBuffer note = new StringBuffer();

		int monthCounts = -1;
		for (int i = 1; i <= numberOfMonths; i++) {
			Calendar paymentDate = Calendar.getInstance();
			paymentDate.setTime(expireDate);
			paymentDate.add(Calendar.DAY_OF_MONTH, monthCounts * 30);
			note.append(paymentDate.getDisplayName(Calendar.MONTH, Calendar.LONG, Locale.US));
			note.append(" ");
			note.append(paymentDate.get(Calendar.YEAR));

			if (i < numberOfMonths) {
				note.append(" , ");
			}

			monthCounts++;

		}
		if (note.toString().trim().isEmpty()) {
			return "";

		}
		return "Invoice for " + note.toString();

	}

	public TransactionDetail calculateTransactionDetail(double numberOfMonths,
			BillContractServiceModel billContractServiceModel) {

		RentingFacility rentingFacility = rentingFacilityService
				.findById(billContractServiceModel.getRentingFacilityId());

		if (rentingFacility == null) {
			return null;
		}
		com.rdongol.rentcollection.model.Service service = rentingFacility.getService();

		TransactionDetail transactionDetail = new TransactionDetail();

		transactionDetail.setRentingFacilityId(rentingFacility.getId());
		transactionDetail.setServiceName(service.getName());
		transactionDetail.setServiceCharge(0);
		transactionDetail.setMinimumCharge(0);

		if (service.getType().equalsIgnoreCase("fixed")) {

			transactionDetail.setCharge(service.getCharge());
			transactionDetail.setTotal(service.getCharge() * numberOfMonths);

		} else {

			transactionDetail.setMinimumCharge(service.getMinimumCharge());
			transactionDetail.setLastUnit(rentingFacility.getUnits());
			transactionDetail.setCurrentUnit(billContractServiceModel.getCurrentUnit());
			transactionDetail.setCharge(0);

			List<TransactionServiceDetail> transactionServiceDetails = calculateTransactionServiceDetails(
					billContractServiceModel, service);

			if (transactionServiceDetails != null && !transactionServiceDetails.isEmpty()) {
				transactionDetail.setTransactionServiceDetail(transactionServiceDetails);
				double serviceCharge = transactionServiceDetails.get(transactionServiceDetails.size() - 1)
						.getServiceCharge();

				transactionDetail.setServiceCharge(serviceCharge);

				transactionDetail.setTotal(getTotalTransactionDetail(transactionServiceDetails, serviceCharge,
						transactionDetail.getMinimumCharge()));

			}

		}

		return transactionDetail;
	}

	protected double getTransactionTotal(List<TransactionDetail> transactionDetails, double charge) {
		double total = 0;

		for (TransactionDetail transactionDetail : transactionDetails) {
			total += transactionDetail.getTotal();
		}

		return total + charge;

	}

	protected double getTotalTransactionDetail(List<TransactionServiceDetail> transactionServiceDetails,
			double serviceCharge, double minimumCharge) {

		double total = 0;
		for (TransactionServiceDetail transactionServiceDetail : transactionServiceDetails) {
			total += transactionServiceDetail.getTotal();
		}
		total += serviceCharge;

		if (total < minimumCharge) {
			return minimumCharge;
		}

		return total;
	}

	public List<TransactionServiceDetail> calculateTransactionServiceDetails(
			BillContractServiceModel billContractServiceModel, com.rdongol.rentcollection.model.Service service) {

		List<ServiceDetail> serviceDetails = serviceDetailService
				.getServiceDetailByServiceIdOrderByVolumeCutoff(service);

		long lastUnit = billContractServiceModel.getLastUnit();
		long currentUnit = billContractServiceModel.getCurrentUnit();

		long unitDifference = currentUnit - lastUnit;
		long ramainingUnit = unitDifference;
		int count = 1;

		List<TransactionServiceDetail> transactionServiceDetails = new LinkedList<TransactionServiceDetail>();

		for (ServiceDetail serviceDetail : serviceDetails) {

			TransactionServiceDetail transactionServiceDetail = new TransactionServiceDetail();

			long lowerRange = serviceDetail.getVolumeCutoff();
			long upperRange = 0;

			transactionServiceDetail.setRate(serviceDetail.getRate());
			transactionServiceDetail.setServiceCharge(serviceDetail.getServiceCharge());

			if (count < serviceDetails.size()) {

				ServiceDetail nextServiceDetail = serviceDetails.get(count);
				upperRange = nextServiceDetail.getVolumeCutoff();

				long unit = upperRange - lowerRange;

				transactionServiceDetail.setVolumeCuttoff(String.valueOf((upperRange - 1)));

				if (unit < ramainingUnit) {
					transactionServiceDetail.setUnit(unit);
					transactionServiceDetail.setTotal(unit * serviceDetail.getRate());
					ramainingUnit -= unit;
					transactionServiceDetails.add(transactionServiceDetail);

				} else {

					transactionServiceDetail.setUnit(ramainingUnit);
					transactionServiceDetail.setTotal(ramainingUnit * serviceDetail.getRate());
					transactionServiceDetails.add(transactionServiceDetail);
					break;

				}

			} else {

				String volumeCutoff = String.valueOf(serviceDetail.getVolumeCutoff()) + "+";
				transactionServiceDetail.setVolumeCuttoff(volumeCutoff);
				transactionServiceDetail.setUnit(ramainingUnit);
				transactionServiceDetail.setTotal(ramainingUnit * serviceDetail.getRate());
				transactionServiceDetails.add(transactionServiceDetail);

			}

			count++;
		}
		return transactionServiceDetails;
	}

	public Transaction billTransaction(Transaction transaction) {
		transaction.setPaid(0);
		transaction.setPaidDate(null);
		return save(transaction, true);
	}

	public Transaction payTransaction(long transactionId, boolean updateRelated) {
		Transaction transaction = findById(transactionId);

		if (transaction == null) {
			return null;
		}

		return payTransaction(transaction, updateRelated);
	}

	public List<Transaction> payTransactions(List<String> transationIds, boolean updateRelated) {

		List<Transaction> transactions = new LinkedList<Transaction>();
		for (String transactionId : transationIds) {
			transactions.add(payTransaction(Long.valueOf(transactionId), updateRelated));
		}

		return transactions;
	}

	public Transaction payTransaction(Transaction transaction, boolean updateRelated) {

		transaction.setPaid(1);
		transaction.setPaidDate(new Date());

		return save(transaction, updateRelated);
	}

	public Transaction save(Transaction transaction, boolean updateRelated) {

		Contract contract = contractService.findById(transaction.getContractId());

		if (transaction.getPaidDate() != null) {
			contract.setLastPaidDate(transaction.getPaidDate());
			contractService.save(contract);
		}

		if (updateRelated) {

			contract.setExpireDate(
					contractService.getExpireDate(contract.getExpireDate(), (int) transaction.getNumberOfMonths()));
			contractService.save(contract);
		}

		for (TransactionDetail transactionDetail : transaction.getTransactionDetail()) {
			RentingFacility rentingFacility = rentingFacilityService.findById(transactionDetail.getRentingFacilityId());
			if (rentingFacility.getService().getType().equalsIgnoreCase("unit")) {
				rentingFacility.setUnits(transactionDetail.getCurrentUnit());
				rentingFacilityService.save(rentingFacility);
			}
		}

		return save(transaction);
	}

	public List<Transaction> getUnpaidBills(long contractId) {
		return transactionRepository.getUnpaidBills(contractId);
	}

	public int countUnpaidBills() {
		return transactionRepository.countUnpaidBills();
	}
}
