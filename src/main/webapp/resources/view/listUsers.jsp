<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
	<meta charset="ISO-8859-1">
	
	<link href="<c:url value="/resources/css/alertify.css" />" rel="stylesheet"> 
	<link href="<c:url value="/resources/css/alertify-bootstrap.css" />" rel="stylesheet">
	<title>User list</title>
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
				                    <h2 class="col-xl-9 col-lg-9 col-md-9 col-sm-9 col-9 topCardHeader">
					 				
						 				User Lists 
						 					
									</h2>
									
				                    <div class="col-xl-3 col-lg-3 col-md-3 col-sm-3 col-3">
										
								        <a href="${contextPath}/resources/view/addUser.jsp" class="btn btn-success topAddButton" >
									    	<i class="fas fa-plus"></i>  &nbsp; Add User
										</a>
										
									</div>
								</div>
						 	</div>
							<div class="card-body">
								<div class="table-responsive">
									<table class="table table-striped table-bordered first" id="userTable">
										<thead>
											<tr>
											    <th>User Name</th>
											    <th>First Name</th>
											    <th>Middle Name</th>
											    <th>Last Name</th>
											    <th>Sex</th>
											    <th>Phone Number</th>
		 									    <th>Email Address</th>
											    <th>Type of User</th>
											    <th>Actions </th>
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

	<div class="loading" style="display:none">
		<img src="${contextPath}/resources/images/loading.gif" class="spinner" >
	</div>
	
</body>

<script src="<c:url value="/resources/js/alertify.js" />" ></script>

<script>
	var table;
	
	function initializeAlertifyTheme(){
		alertify.defaults.transition = "slide";
		alertify.defaults.theme.ok = "btn btn-primary";
		alertify.defaults.theme.cancel = "btn btn-danger";
		alertify.defaults.theme.input = "form-control";
	}	
	
	
	jQuery(document).ready(function(){

		initializeAlertifyTheme()
		
		loadTableData();
		
		jQuery("#userTable").on("click",".editUser",function(){
			editUser(jQuery(this).attr("userId"));
		})
		
		jQuery("#userTable").on("click",".deleteUser",function(){
			jQuery(".actionButton").prop('disabled', true);
			var userId=jQuery(this).attr("userId")
			alertify.confirm(
				"Confirm",
				"Are you sure you want to delete the User",
				function(){deleteUser(userId)},
				function(){jQuery(".actionButton").prop('disabled', false);}
			)
		})
		
		
	});
	
	function editUser(userId){
		window.location.href="${contextPath}/resources/view/addUser.jsp?id="+userId;
	}
	
	function deleteUser(userId){
		jQuery(".loading").show();
		jQuery.ajax({
			method : "DELETE",
			url : "${contextPath}/user/"+userId,
		}).done(function(data){
			jQuery(".loading").hide();
			$('#userTable').DataTable().ajax.reload();
			jQuery(".actionButton").prop('disabled', false);
		}).fail(function(){
			jQuery(".loading").hide();
			jQuery(".actionButton").prop('disabled', false);
			alertify.alert("<div style='color:red'>An Error occured while trying to delete the user.</div>").setHeader("<b>Error</b>");

		});
	}
	
	function loadTableData(){
		table = jQuery("#userTable").DataTable({
			"processing": true,
			"serverSide": true,
			"ajax":{
				"url":"${contextPath}/user/listUsers",
				 "type": "POST",
				 "contentType": "application/json",
				 "data": function(data){
					return JSON.stringify(data);
				}
			},
			"columns":[
				{data : 0 , name:"userName"},
				{data : 1 , name:"firstName"},
				{data : 2 , name:"middleName"},
				{data : 3 , name:"lastName"},
				{data : 4 , name:"sex"},
				{data : 5 , name:"phoneNumber"},
				{data : 6 , name:"emailAddress"},
				{data : 7 , name:"typeOfUser"},
				{data : 8 , name:"actions",searchable : false , orderable:false}
			]
		});
	}
</script>
</html>