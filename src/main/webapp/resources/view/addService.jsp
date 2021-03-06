<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link href="<c:url value="/resources/css/alertify.css" />" rel="stylesheet"> 
<link href="<c:url value="/resources/css/alertify-bootstrap.css" />" rel="stylesheet">

<title>Add Service</title>
</head>
<body>
	<div class="dashboard-main-wrapper">
		<%@ include file="/resources/view/menu.jsp" %> 
		<div class="dashboard-wrapper">
			<div class="container-fluid dashboard-content ">
				<div class="row">
					<div class="col-xl-10">
					
						 <div class="row">
						 	<div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
								<div class="card">
									
									<div class="card-header">
								 		<div class="row">
								 			<div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
							                    <h2 class="pageheader-title" id="pageheader-title">
							 						Add Service
												</h2>
												<p class="pageheader-text">Please fill all the required fields(<span class="requiredField">*</span>) to add the service</p>
								 			</div>
										</div>
								 	</div>
								 	
							 		<form id="serviceForm">
									 	<div class="card-body">
								 			<div class="row">
								 				<input id="id" name="id" type="hidden">
								 				<div class="form-group col-xl-3 col-lg-3 col-md-6 col-sm-12 col3">
	                                                <label for="name" class="col-form-label">Name<span class="requiredField">*</span></label>
	                                                <input id="name" name="name" type="text" class="form-control requiredInputs" value=''>
													<div class="errorFeedback" id="name-errorFeedback"></div>
	                                            </div>
	                                            
	                                           <div class="form-group col-xl-3 col-lg-3 col-md-6 col-sm-12 col3">
	                                                <label for="minimumCharge" class="col-form-label">Minimum Charge</label>
	                                                <input id="minimumCharge" name="minimumCharge" type="number" min=0 class="form-control number" value=''>
													<div class="errorFeedback" id="minimumCharge-errorFeedback"></div>
	                                            </div>
	                                            
	                                            <div class="form-group col-xl-3 col-lg-3 col-md-6 col-sm-12 col3">
	                                                <label for="charge" class="col-form-label">Charge</label>
	                                                <input id="charge" name="charge" type="number" min=0 class="form-control number" value=''>
													<div class="errorFeedback" id="charge-errorFeedback"></div>
	                                            </div>
    
                                                <div class="form-group col-xl-3 col-lg-3 col-md-6 col-sm-12 col3">
                                            
		                                            <label for="type" class="col-form-label">Type</label>
													<select class="form-control" id="type" name="type">
														<option value="fixed" >Fixed</option>
														<option value="unit" >Unit</option>
													</select>
		
													<div class="errorFeedback" id="type-errorFeedback">
													</div>
												</div>									 			
								 			</div>
									 	</div>
									 	
									 	<div class="card-body border-top" id="serviceDetails">
									 		<div class="row">
                                    	    	<div class="col-xl-4 col-lg-4 col-md-4 col-sm-4 col-4">
                                    	    		Service Details
                                    	    	</div>
                                    	    	
                                    	    	<div class="col-xl-5 col-lg-5 col-md-5 col-sm-5 col-5">
                                    	    		<div class="errorFeedback" id="serviceDetails-errorFeedback">
													</div>
                                    	    	</div>
                                    	    	
                                    	    	<div class="col-xl-3 col-lg-3 col-md-3 col-sm-3 col-3">
										
											        <Button class="btn btn-success topAddButton" id="addServiceDetail" >
												    	<i class="fas fa-plus"></i>  &nbsp; Add Service Details
													</Button>
													
												</div>
											</div>
											
                                        </div>
                                        
                                        <div class="card-body border-top">
                                        
                                        	<div class="row">
												<div class="form-group col-xl-2 col-lg-2 col-md-2 col-sm-2 col-2">
													<button class="btn btn-primary" id="addService">
								 						Add Service
													</button>
												</div>	
											</div>
                                        </div>
                                        
							 		</form>
								 	
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
	
	var serviceDetailsCount = 0;
	var errorFields = []
	var mode ="save";
	var id=0;
	
	function initializeAlertifyTheme(){
		alertify.defaults.transition = "slide";
		alertify.defaults.theme.ok = "btn btn-primary";
		alertify.defaults.theme.cancel = "btn btn-danger";
		alertify.defaults.theme.input = "form-control";
	}	
	
	jQuery(document).ready(function() {
		initializeAlertifyTheme()
		id=getURLParameter("id")
		
		if(id != undefined){
			mode="edit"
			jQuery("#addService").html("Edit Service")
			jQuery("#pageheader-title").html("Edit Service")
			getService(id)
		}else{
			mode ="save";
			jQuery("#addService").html("Add Service")
			jQuery("#pageheader-title").html("Add Service")
		}
		
		toggleServiceDetail(jQuery("#type").val())
		
		jQuery("#type").on("change",function(){
			toggleServiceDetail(jQuery(this).val())
		})
		
		jQuery("#addServiceDetail").on("click",function(){
			event.preventDefault();
			jQuery("#serviceDetails").append(getServiceDetail())
			
		})
		
		jQuery("#serviceDetails").on("click",".RemoveServiceDetail" ,function(){
			
			var count = jQuery(this).attr("count");
			jQuery("#serviceDetail-"+count).prev("hr").remove()

			jQuery("#serviceDetail-"+count).remove();
			
		})
		
		jQuery("#addService").on("click",function(){
			jQuery("#addService").prop('disabled',true);
			event.preventDefault();
			removeErrorHighlights()
			if (validateInputs()) {
				if(mode =="save"){
					saveService()
				}else{
					updateService(id)
				}
			} else {
				jQuery("#addService").prop('disabled',false);
				highlightErrorFields()

			}
		})
	});
	
	function getService(id){
		jQuery.ajax({
			method:"GET",
			url:"${contextPath}/service/"+id
		}).done(function(data){
			loadServiceData(data)
		});	
	}
	
	function loadServiceData(data){
		jQuery("#id").val(data.id);
		jQuery("#name").val(data.name);
		jQuery("#minimumCharge").val(data.minimumCharge);
		jQuery("#charge").val(data.charge);
		jQuery("#name").val(data.name);
		jQuery("#type option[value="+data.type+"]").attr("selected","selected");
		
		toggleServiceDetail(jQuery("#type").val())
		if(data.type=="unit"){
			loadServiceDetailData(data.serviceDetail)
		}

	}
	
	function loadServiceDetailData(serviceDetails){

		var html="";
		

		for(var i = 0 ; i<serviceDetails.length; i++){
			html += '<hr>'    
			
			html += '<div class="row serviceDetail" id="serviceDetail-'+serviceDetailsCount+'">'
			html +='<input id="serviceDetailId-'+serviceDetailsCount+'" name="id" type="hidden" class="serviceDetailId" value="'+serviceDetails[i].id+'">'
			html += '<div class="form-group col-xl-3 col-lg-3 col-md-6 col-sm-12 col3">'
			html += '<label for="rate-'+serviceDetailsCount+'" class="col-form-label">Rate<span class="requiredField">*</span></label>'
			html += '<input id="rate-'+serviceDetailsCount+'" name="rate" type="number" min=0 class="rate form-control requiredInputs number" value="'+serviceDetails[i].rate+'">'
			html += '<div class="errorFeedback" id="rate-'+serviceDetailsCount+'-errorFeedback"></div>'
			html += '</div>'
			html += '<div class="form-group col-xl-3 col-lg-3 col-md-6 col-sm-12 col3">'
			html += '<label for="volumeCutoff-'+serviceDetailsCount+'" class="col-form-label">Volume Cutoff<span class="requiredField">*</span></label>'
			html += '<input id="volumeCutoff-'+serviceDetailsCount+'" name="volumeCutoff" type="number" min=0 class="volumeCutoff form-control requiredInputs number" value="'+serviceDetails[i].volumeCutoff+'">'
			html += '<div class="errorFeedback" id="volumeCutoff-'+serviceDetailsCount+'-errorFeedback"></div>'
			html += '</div>'
			html += '<div class="form-group col-xl-3 col-lg-3 col-md-6 col-sm-12 col3">'
			html += '<label for="serviceCharge-'+serviceDetailsCount+'" class="col-form-label">Service Charge</label>'
			html += '<input id="serviceCharge-'+serviceDetailsCount+'" name="serviceCharge" type="number" min=0 class="serviceCharge form-control number" value="'+serviceDetails[i].serviceCharge+'">'
			html += '<div class="errorFeedback" id="serviceCharge-'+serviceDetailsCount+'-errorFeedback"></div>'
			html += '</div>'
			html += '<div class="form-group col-xl-3 col-lg-3 col-md-6 col-sm-12 col3">'
			html += '<i class="actionButton RemoveServiceDetail fas fa-trash-alt" style = "color:red" id="RemoveServiceDetail-'+serviceDetailsCount+'" count ="'+serviceDetailsCount+'"></i>'
			html += '</div>'
			html += '</div>'
			
			serviceDetailsCount++;
		}
		
		jQuery("#serviceDetails").append(html);
		
	}

	function getURLParameter(param){
		
		var pageURL = window.location.search.substring(1);
		var urlVariables = pageURL.split('&')
		for(var i=0;i<urlVariables.length;i++){
			var parameterName=urlVariables[i].split('=');
			if(parameterName[0] == param){
				return decodeURIComponent(parameterName[1]);
			}
		}
	}
	
	function highlightErrorFields() {
		if (errorFields.length < 1) {
			return;
		}

		errorFields.forEach(function(value, index) {
			var id = value.id;
			var message = value.message
			jQuery("#" + id).css("border-color", "red");
			jQuery("#" + id + "-errorFeedback").html(message)
		})
	}
	
	function validateInputs() {

		if(!validateRequiredFields()){
			return false;
		}
		
		if(!validateOtherFields()){
			return false;
		}
		
		return true;
	}
	
	function validateRequiredFields() {
		errorFields = []
		jQuery(".requiredInputs:visible").each(function() {
			var errorField = {};
			if (this.value.trim() == "") {
				errorField.id = jQuery(this).attr("id");
				errorField.message = "Required field connot be empty";
				errorFields.push(errorField)
			}
		})
		return !errorFields.length > 0
	}
	
	function validateOtherFields(){
		errorFields = []
	 	validateCharge();
		if(mode =="save"){
			doesServiceNameExists()
		}
		validateServiceDetails();
		validateNumberFields();
		return !errorFields.length > 0;
		
	}
	
	function validateNumberFields(){
		jQuery(".number:visible").each(function() {
			var errorField = {};
			if (this.value.trim() != "" && parseInt(this.value.trim()) <0 ) {
				errorField.id = jQuery(this).attr("id");
				errorField.message = "Cannot be less than 0";
				errorFields.push(errorField)
			}
		})
	}
	
	function validateServiceDetails(){
		
		if(jQuery("#type").val() == "unit" && jQuery(".serviceDetail").length == 0){
			var errorField = {};
			errorField.id = "serviceDetails"
			errorField.message = "Service Details should be added for 'unit type' services ";
			errorFields.push(errorField)
		}

	}
	
	function validateCharge(){
		
		var type=jQuery("#type").val();
		var charge = jQuery("#charge").val();
		
		if("fixed"== type && (charge.trim()=="")){
			var errorField = {};
			errorField.id = "charge"
			errorField.message = "Charge should be filled for 'fixed type' services";
			errorFields.push(errorField)
			
		}
	}
	
	function toggleServiceDetail(serviceType){
		if(serviceType == "fixed"){
			jQuery("#serviceDetails").hide();
		}else{
			jQuery("#serviceDetails").show();
		}
	}
	
	function getServiceDetail(){
		var html="";

		html += '<hr>'
		html += '<div class="row serviceDetail" id="serviceDetail-'+serviceDetailsCount+'">'
		html +='<input id="serviceDetailId-'+serviceDetailsCount+'" name="id" type="hidden" class="serviceDetailId">'
		html += '<div class="form-group col-xl-3 col-lg-3 col-md-6 col-sm-12 col3">'
		html += '<label for="rate-'+serviceDetailsCount+'" class="col-form-label">Rate<span class="requiredField">*</span></label>'
		html += '<input id="rate-'+serviceDetailsCount+'" name="rate" type="number" min=0 class="rate form-control requiredInputs number" value="">'
		html += '<div class="errorFeedback" id="rate-'+serviceDetailsCount+'-errorFeedback"></div>'
		html += '</div>'
		html += '<div class="form-group col-xl-3 col-lg-3 col-md-6 col-sm-12 col3">'
		html += '<label for="volumeCutoff-'+serviceDetailsCount+'" class="col-form-label">Volume Cutoff<span class="requiredField">*</span></label>'
		html += '<input id="volumeCutoff-'+serviceDetailsCount+'" name="volumeCutoff" min=0 type="number" class="volumeCutoff form-control requiredInputs number" value="">'
		html += '<div class="errorFeedback" id="volumeCutoff-'+serviceDetailsCount+'-errorFeedback"></div>'
		html += '</div>'
		html += '<div class="form-group col-xl-3 col-lg-3 col-md-6 col-sm-12 col3">'
		html += '<label for="serviceCharge-'+serviceDetailsCount+'" class="col-form-label">Service Charge</label>'
		html += '<input id="serviceCharge-'+serviceDetailsCount+'" name="serviceCharge" min=0 type="number" class="serviceCharge form-control number" value="">'
		html += '<div class="errorFeedback" id="serviceCharge-'+serviceDetailsCount+'-errorFeedback"></div>'
		html += '</div>'
		html += '<div class="form-group col-xl-3 col-lg-3 col-md-6 col-sm-12 col3">'
		html += '<i class="actionButton RemoveServiceDetail fas fa-trash-alt" style = "color:red" id="RemoveServiceDetail-'+serviceDetailsCount+'" count ="'+serviceDetailsCount+'"></i>'
		html += '</div>'
		html += '</div>'
		
		
		serviceDetailsCount++;
		
		return html;
	}
	
	function getServiceData(mode){
		var serviceData= new Object();
		if(mode=="edit"){
			serviceData.id=jQuery("#id").val();
		}
		serviceData.name=jQuery("#name").val();
		serviceData.minimumCharge=jQuery("#minimumCharge").val();
		serviceData.charge=jQuery("#charge").val();
		serviceData.type=jQuery("#type").val();;

		if("unit"==jQuery("#type").val()){
			
			serviceData.serviceDetail = getServiceDetailsData(mode)
	
		}
		
		return JSON.stringify(serviceData)
	}
	
	function getServiceDetailsData(mode){
		var serviceDetails = []
		
		jQuery(".serviceDetail").each(function(){
			var serviceDetail = new Object();
			if(mode=="edit"){
				serviceDetail.id=$(this).find('.serviceDetailId').val();
			}
			serviceDetail.rate = $(this).find('.rate').val();
			serviceDetail.volumeCutoff = $(this).find('.volumeCutoff').val();
			serviceDetail.serviceCharge = $(this).find('.serviceCharge').val();
			serviceDetails.push(serviceDetail)

		})

		return serviceDetails;
		
		
	}
	
	function saveService(){
		jQuery(".loading").show();
		jQuery.ajax({
			"method" : "POST",
			"url" : "${contextPath}/service",
			"contentType": 'application/json; charset=UTF-8',		
			"data":getServiceData(mode)
		}).done(function(data){
			window.location.href="${contextPath}/resources/view/listServices.jsp";
		}).fail(function(){
			jQuery(".loading").hide();
			jQuery("#addUser").prop("disabled",false);
			alertify.alert("<div style='color:red'>An Error occured while creating the Service.</div>").setHeader("<b>Error</b>");
		
		});
		
	}
	
	function updateService(id){
		jQuery(".loading").show();
		jQuery.ajax({
			"method" : "PUT",
			"url" : "${contextPath}/service/"+id,
			"contentType": 'application/json; charset=UTF-8',		
			"data":getServiceData(mode)
		}).done(function(data){
			window.location.href="${contextPath}/resources/view/listServices.jsp";
		}).fail(function(){
			jQuery(".loading").hide();
			jQuery("#addUser").prop("disabled",false);
			alertify.alert("<div style='color:red'>An Error occured while editing the Service.</div>").setHeader("<b>Error</b>");
		
		});
	}
	
	function removeErrorHighlights(){
		
		jQuery(".errorFeedback").html("");
		jQuery(".form-control").css("border-color","");

	}
	
	function doesServiceNameExists(){
		var name=jQuery("#name").val()
		jQuery.ajax({
			method : "GET",
			url :"${contextPath}/service/serviceExists/"+name,
			async: false,
			success:function(data){
				if(data == "true"){
					var errorField = {};
					errorField.id = "name"
					errorField.message = "Service Name already exists";
					errorFields.push(errorField)
				}
			}
		});
	}	
	
</script>

<Style>
	.RemoveServiceDetail{
		padding-top : 40px;
	}
</Style>
</html>