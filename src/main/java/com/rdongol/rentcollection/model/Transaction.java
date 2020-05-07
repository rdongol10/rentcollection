package com.rdongol.rentcollection.model;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Transaction {

	private long id;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private String transactionNumber;

	private long contractId;

	private Date billedDate;

	private int paid;

	private Date paidDate;

	private int numberOfMonths;

	private double contractCharge;

	private double totalCharge;

	public Transaction() {

	}

	public Transaction(long id, String transactionNumber, long contractId, Date billedDate, int paid, Date paidDate,
			int numberOfMonths, double contractCharge, double totalCharge) {
		super();
		this.id = id;
		this.transactionNumber = transactionNumber;
		this.contractId = contractId;
		this.billedDate = billedDate;
		this.paid = paid;
		this.paidDate = paidDate;
		this.numberOfMonths = numberOfMonths;
		this.contractCharge = contractCharge;
		this.totalCharge = totalCharge;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getTransactionNumber() {
		return transactionNumber;
	}

	public void setTransactionNumber(String transactionNumber) {
		this.transactionNumber = transactionNumber;
	}

	public long getContractId() {
		return contractId;
	}

	public void setContractId(long contractId) {
		this.contractId = contractId;
	}

	public Date getBilledDate() {
		return billedDate;
	}

	public void setBilledDate(Date billedDate) {
		this.billedDate = billedDate;
	}

	public int getPaid() {
		return paid;
	}

	public void setPaid(int paid) {
		this.paid = paid;
	}

	public Date getPaidDate() {
		return paidDate;
	}

	public void setPaidDate(Date paidDate) {
		this.paidDate = paidDate;
	}

	public int getNumberOfMonths() {
		return numberOfMonths;
	}

	public void setNumberOfMonths(int numberOfMonths) {
		this.numberOfMonths = numberOfMonths;
	}

	public double getContractCharge() {
		return contractCharge;
	}

	public void setContractCharge(double contractCharge) {
		this.contractCharge = contractCharge;
	}

	public double getTotalCharge() {
		return totalCharge;
	}

	public void setTotalCharge(double totalCharge) {
		this.totalCharge = totalCharge;
	}

}