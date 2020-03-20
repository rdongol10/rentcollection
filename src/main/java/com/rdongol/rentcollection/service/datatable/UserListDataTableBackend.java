package com.rdongol.rentcollection.service.datatable;

import java.util.LinkedList;
import java.util.List;

import javax.persistence.Query;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
@Qualifier("userListDataTableBackend")
public class UserListDataTableBackend extends AbstractDataTableBackend {

	public UserListDataTableBackend() {

	}

	@Override
	protected void initializeTableColumns() {

		tableColumns.add("login_name");
		tableColumns.add("first_name");
		tableColumns.add("middle_name");
		tableColumns.add("last_name");
		tableColumns.add("sex");
		tableColumns.add("phone_number");
		tableColumns.add("email_address");
		tableColumns.add("type_of_user");

	}

	@Override
	protected void setSelectCriteria() {
		selectCriteria = " Select id,login_name, first_name, middle_name, last_name, sex, phone_number, email_address, type_of_user  ";
	}

	@Override
	protected void setFromCriteria() {
		fromCriteria = " From USER as user";
	}

	@Override
	public String getQuery() {

		StringBuffer query = new StringBuffer();
		query.append(selectCriteria);
		query.append(fromCriteria);
		query.append(whereCriteria);
		query.append(searchFilterCriteria);
		query.append(orderCriteria);
		query.append(paginationCriteria);

		return query.toString();
	}

	@SuppressWarnings("unchecked")
	@Override
	protected List<List<String>> getQueryResults() {
		List<List<String>> tableData = new LinkedList<List<String>>();

		Query query = entityManager.createNativeQuery(getQuery());

		List<Object[]> users = query.getResultList();
		for (Object[] user : users) {

			List<String> data = new LinkedList<String>();

			data.add(String.valueOf(user[1]));
			data.add(String.valueOf(user[2]));
			data.add(String.valueOf(user[3]));
			data.add(String.valueOf(user[4]));
			data.add(String.valueOf(user[5]));
			data.add(String.valueOf(user[6]));
			data.add(String.valueOf(user[7]));
			data.add(String.valueOf(user[8]));

			tableData.add(data);
		}

		return tableData;

	}

}
