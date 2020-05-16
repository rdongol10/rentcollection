<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<meta charset="ISO-8859-1">
<link href="<c:url value="/resources/css/select2.css" />" rel="stylesheet">
<link href="<c:url value="/resources/css/select2-bootstrap.min.css" />" rel="stylesheet">
<link href="<c:url value="/resources/css/displayDetails.css" />" rel="stylesheet">
<link href="<c:url value="/resources/css/daterangepicker.css" />" rel="stylesheet">

<style>
	.col3{
		max-width : 224px;
	}
</style>
<title>Transactions</title>
</head>
<body>
	<div class="dashboard-main-wrapper">
		<%@ include file="menu.jsp" %>
		<div class="dashboard-wrapper">
			<div class="container-fluid dashboard-content ">
				<div class="row">
                    
                    <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
	                    <div class="card ">
	                   		<div class="card-header">
	                   			<div class="row">
				                    <h2 class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12 topCardHeader">
					 				
						 				Transactions
						 				
									</h2>
								</div>
	                   		</div>
	                   		
	                   		<div class="card-body">
	                   		
	                   			<div class="row">
									<div class="col-xl-3 col-lg-3 col-md-3 col-sm-12  col3 form-group">
										<label for="billedDate" class="col-form-label" > Billed Date </label>
										<input type="text" id="billedDate" class="dateRangePicer form-control ">
									</div>
									
									<div class="col-xl-3 col-lg-3 col-md-3 col-sm-12  col3 form-group">
										<label for="rentee" class="col-form-label " > Rentee </label>
										<select class="form-control rentee" id="rentee"></select>
									</div>
									
									<div class="col-xl-1 col-lg-1 col-md-1 col-sm-12  col1 form-group text-center">
										<br><br>	
										<i class="fas fa-sync-alt fa-lg actionButton" id="clearRentee"></i>
									
									</div>
									
									<div class="col-xl-3 col-lg-3 col-md-3 col-sm-12  col3 form-group">
										<label for="renting" class="col-form-label col3" > Renting </label>
										<select class="form-control rentee" id="renting"></select>
										
									</div>
									
									<div class="col-xl-1 col-lg-1 col-md-1 col-sm-12  col1 form-group text-center">
										<br><br>
										<i class="fas fa-sync-alt fa-lg actionButton" id="clearRenting"></i>
									
									</div>
									
	                   			</div>
	                   			
	                   			<div class="row">
									<div class="col-xl-3 col-lg-3 col-md-3 col-sm-12 form-group">
											<br>
											<button class="btn btn-success" id="searchTransaction"><i class="fas fa-search"></i> &nbsp; Search</button>
									</div>
								</div>	
									
	                   			<br><hr>
	                   			<div class="table-responsive">
	                   				<table class="table table-striped table-bordered first" id="transactionTable">
										<thead>
											<tr>
												<th>Invoice No.</th>
											    <th>Renting Name</th>
											    <th>Rentee Name</th>
											    <th>Billed Date</th>
											    <th>Paid Date</th>
											    <th>Total Charge</th>
   											    <th>Note</th>
   											    <th>Actions</th>
											</tr>
										</thead>
									</table>	
	                   			</div>
	                   		</div>
	                    </div>
                    </div>
                    
				</div>
			</div>
		</div>
	</div>
</body>

<script src="<c:url value="/resources/js/select2.min.js" />" ></script>
<script src="<c:url value="/resources/js/displayDetails.js" />" ></script>
<script src="<c:url value="/resources/js/moment.min.js" />"></script>
<script src="<c:url value="/resources/js/daterangepicker.js" />"></script>


<script type="text/javascript">
	
	var table;
	
	jQuery(document).ready(function(){

		jQuery(".dateRangePicer").daterangepicker();

		jQuery("#rentee").select2({
			theme: "bootstrap",
			ajax:{
				method : "POST",
				url :"${contextPath}/rentee/getRenteeForSelect2",
				dataType: 'json',
				data:function(param){
					var value ={search : param.term}
					return value;
				}, 
				processResults: function (data) {
					return {
						results: data
					};
				}
			}
		});
		
		jQuery("#renting").select2({
			theme: "bootstrap",
			ajax:{
				method : "POST",
				url :"${contextPath}/renting/getAllRentingForSelect2",
				dataType: 'json',
				data:function(param){
					var value ={search : param.term}
					return value;
				}, 
				processResults: function (data) {
					return {
						results: data
					};
				}
			}
		});
		
		jQuery("#clearRentee").on("click",function(){
			clearRentee()
		})
		
		jQuery("#clearRenting").on("click",function(){
			clearRenting()
		})
		
		jQuery("#searchTransaction").on("click",function(){
			$('#transactionTable').DataTable().ajax.reload();
		})
		
		loadTableData()
		
		
	})
	
	function clearRentee(){
		jQuery("#rentee").empty()

	}
	
	function clearRenting(){
		jQuery("#renting").empty()

	}
	
	function loadTableData(){
		table = jQuery("#transactionTable").DataTable({
			"processing": true,
			"serverSide": true,
			"ajax":{
				"url":"${contextPath}/transaction/listTransactions",
				 "type": "POST",
				 "contentType": "application/json",
				 "data": function(data){
				 	data.billedDate = jQuery("#billedDate").val();
				 	data.renteeId = jQuery("#rentee").val();
				 	data.rentingId = jQuery("#renting").val();

				 	
					return JSON.stringify(data);
				}
			},
			"columns":[
				{data : 0 , name:"id"},
				{data : 1 , name:"name"},
				{data : 2 , name:"first_name"},
				{data : 3 , name:"billed_date"},
				{data : 4 , name:"paid_Date"},
				{data : 5 , name:"total_charge"},
				{data : 6 , name:"note"},
				{data : 7 , name:"actions",searchable : false , orderable:false}
			]
		});
		
	}
</script>

</html>