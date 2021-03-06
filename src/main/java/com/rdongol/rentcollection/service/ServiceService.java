package com.rdongol.rentcollection.service;

import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.rdongol.rentcollection.model.ServiceDetail;
import com.rdongol.rentcollection.model.ServiceModel;
import com.rdongol.rentcollection.repository.ServiceRepository;

@Service
public class ServiceService {

	@Autowired
	private ServiceRepository serviceRepository;

	@Autowired
	private ServiceDetailService serviceDetailService;

	public List<com.rdongol.rentcollection.model.Service> findAll() {
		return (List<com.rdongol.rentcollection.model.Service>) serviceRepository.findAll();
	}

	public com.rdongol.rentcollection.model.Service findById(Long id) {

		Optional<com.rdongol.rentcollection.model.Service> service = serviceRepository.findById(id);

		if (!service.isPresent()) {
			return null;
		}
		return service.get();
	}

	public com.rdongol.rentcollection.model.Service save(com.rdongol.rentcollection.model.Service service) {

		List<ServiceDetail> serviceDetails = service.getServiceDetail();

		if (serviceDetails != null) {
			for (ServiceDetail detail : serviceDetails) {
				detail.setService(service);
			}
		}

		service.setActive(1);
		return serviceRepository.save(service);

	}

	public void deleteById(Long id) {
		serviceRepository.deleteById(id);
	}

	public boolean existServiceByName(String name) {
		return serviceRepository.existsServiceByName(name);
	}

	public int toggleActiveStatus(Long id) {

		if (findById(id) == null) {
			return -1;
		}

		com.rdongol.rentcollection.model.Service service = findById(id);

		int active = 1;

		if (service.getActive() == 1) {
			active = 0;
		}

		return serviceRepository.updateServiceActiveStatus(id, active);

	}

	public com.rdongol.rentcollection.model.Service update(Long id, com.rdongol.rentcollection.model.Service service) {

		if (findById(id) == null) {
			return null;
		}
		adjustServiceDetailsforUpdate(service);
		List<ServiceDetail> serviceDetails = service.getServiceDetail();

		if (serviceDetails != null) {
			for (ServiceDetail detail : serviceDetails) {
				detail.setService(service);
			}
		}

		service.setActive(findById(id).getActive());

		return serviceRepository.save(service);
	}

	private void adjustServiceDetailsforUpdate(com.rdongol.rentcollection.model.Service service) {

		List<ServiceDetail> currentServiceDetails = serviceDetailService.getServiceDetailByService(service);

		if (currentServiceDetails == null || currentServiceDetails.isEmpty()) {
			return;
		}

		if (service.getServiceDetail() == null || service.getServiceDetail().isEmpty()) {
			serviceDetailService.deleteServiceDetails(currentServiceDetails);
			return;
		}

		List<ServiceDetail> serviceDetailsToDelete = getServiceDetailsToDelete(service, currentServiceDetails);

		if (!serviceDetailsToDelete.isEmpty()) {
			serviceDetailService.deleteServiceDetails(serviceDetailsToDelete);
		}

	}

	private List<ServiceDetail> getServiceDetailsToDelete(com.rdongol.rentcollection.model.Service service,
			List<ServiceDetail> currentServiceDetails) {
		List<ServiceDetail> serviceDetailsToDelete = new LinkedList<ServiceDetail>();
		for (ServiceDetail currentServiceDetail : currentServiceDetails) {
			boolean delete = true;

			for (ServiceDetail serviceDetail : service.getServiceDetail()) {
				if (serviceDetail.getId() == currentServiceDetail.getId()) {
					delete = false;
					break;
				}
			}

			if (delete) {
				serviceDetailsToDelete.add(currentServiceDetail);
			}

		}
		return serviceDetailsToDelete;
	}

	public List<ServiceDetail> getServiceDetails(Long id) {
		if (findById(id) == null) {
			return null;
		}
		com.rdongol.rentcollection.model.Service service = findById(id);
		return service.getServiceDetail();
	}

	public List<ServiceModel> getServiceModels() {
		List<com.rdongol.rentcollection.model.Service> services = findAll();

		List<ServiceModel> serviceModels = new LinkedList<ServiceModel>();
		for (com.rdongol.rentcollection.model.Service service : services) {
			ServiceModel serviceModel = new ServiceModel(service.getId(), service.getName() , service.getType());
			serviceModels.add(serviceModel);
		}
		return serviceModels;
	}
}
