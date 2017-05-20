    <%--
  ~ Copyright (c) 2016, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
  ~
  ~  WSO2 Inc. licenses this file to you under the Apache License,
  ~  Version 2.0 (the "License"); you may not use this file except
  ~  in compliance with the License.
  ~  You may obtain a copy of the License at
  ~
  ~    http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied.  See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
  --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.IdentityManagementEndpointConstants" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.IdentityManagementEndpointUtil" %>

<%
    boolean error = IdentityManagementEndpointUtil.getBooleanValue(request.getAttribute("error"));
    String errorMsg = IdentityManagementEndpointUtil.getStringValue(request.getAttribute("errorMsg"));

    boolean isEmailNotificationEnabled = false;

    isEmailNotificationEnabled = Boolean.parseBoolean(application.getInitParameter(
                IdentityManagementEndpointConstants.ConfigConstants.ENABLE_EMAIL_NOTIFICATION));
%>
<fmt:bundle basename="org.wso2.carbon.identity.mgt.endpoint.i18n.Resources">
    <html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Recover password - John Snow LABS</title>

        <link rel="icon" href="/images/favicon.png" type="image/x-icon"/>
        <link href="libs/bootstrap_3.3.5/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/Roboto.css" rel="stylesheet">
        <link href="/css/style.css" rel="stylesheet">
    <style>
    .error{
    color:red !important;
    }
    </style>
        <!--[if lt IE 9]>
        <script src="js/html5shiv.min.js"></script>
        <script src="js/respond.min.js"></script>
        <![endif]-->
    </head>

    <body>
    <div class="wrapper">
        <!-- header -->
         <nav class="navbar navbar-default">
            <div class="container">
                <div class="navbar-header">
                    <a href="#" class="navbar-brand">
                        <img src="/images/logo.png" alt="JohnSnowLABs" title="JohnSnowLABs" class="img-responsive">
                    </a>
                </div>
            </div>
        </nav>

        <!-- page content -->
        <div class="container body-wrapper">

            <div class="row">
                <!-- content -->
                <div class="col-sm-offset-1 col-sm-10 col-md-offset-2 col-md-8 col-lg-offset-3 col-lg-6">
                    <div class="form form-wrapper">
                        <h4 class="margin-none">Recover Password</h4>


                        <div class="login-form mailform">
                            <form method="post" action="verify.do" id="recoverDetailsForm">
                                <% if (error) { %>
                                <div class="alert alert-danger" id="server-error-msg">
                                    <%= Encode.forHtmlContent(errorMsg) %>
                                </div>
                                    <% } %>
                                <div class="alert alert-danger" id="error-msg" hidden="hidden"></div>

                                <div class="txttitle">
                                    <h5>Enter below details to recover your password</h5>
                                </div>

                                <div class="form-group">
                                    <label class="mfInput">
                                        <input id="username" name="username" type="text" class="form-control" tabindex="0" required/>
                                        <span class="mfIcon">
                                            <span></span>
                                        </span>
                                        <span class="mfPlaceHolder">Username</span>
                                    </label>
                                </div>
                                <%
                                    if (isEmailNotificationEnabled) {
                                %>
                                <div class="form-group radio-wrapper">
                                    <div class="radio">
                                            <input type="radio" id="recoveryOption1" name="recoveryOption" value="EMAIL" checked/>
                                            <label for="recoveryOption1">Recover with Email</label>
                                    </div>
                                    <div class="radio">
                                            <input type="radio" id="recoveryOption2" name="recoveryOption" value="SECURITY_QUESTIONS"/>
                                            <label for="recoveryOption2">Recover with Security Questions</label>
                                    </div>
                                </div>
                                <%
                                } else {
                                %>
                                <div class="form-group">
                                    <input type="hidden" name="recoveryOption" value="SECURITY_QUESTIONS"/>
                                </div>
                                <%
                                    }
                                %>

                                <%
                                    String callback = Encode.forHtmlAttribute
                                            (request.getParameter("callback"));
                                    if (callback != null) {
                                %>
                                <div>
                                    <input type="hidden" name="callback" value="<%=callback %>"/>
                                </div>
                                <%
                                    }
                                %>
                                <div class="form-group form-actions text-center">
                                    <button id="recoverySubmit" class="btn btn-default" type="submit">Submit</button>

                                    <button id="recoveryCancel"
                                            class="btn btn-primary"
                                            onclick="location.href='<%=Encode.forJavaScript(IdentityManagementEndpointUtil.getUserPortalUrl(
                                                application.getInitParameter(IdentityManagementEndpointConstants.ConfigConstants.USER_PORTAL_URL)))%>';">
                                        Cancel
                                    </button>

                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
                <!-- /content/body -->

            </div>
        </div>
    </div>

    <!-- footer -->
    <footer class="footer text-center">
        <div class="container">
    <p><script>document.write(new Date().getFullYear());</script> <a href="http://wso2.com/" target="_blank"><i class="fw fw-wso2"></i> Inc</a>. All Rights Reserved.</p>
        </div>
    </footer>


    <script src="/js/jquery-3.2.1.min.js"></script>
    <script src="libs/bootstrap_3.3.5/js/bootstrap.min.js"></script>
    <script src="js/jquery.validate.js"></script>

    <script>


    $("#recoverDetailsForm").validate({
    rules : {
    username : {
    required : true
    }
    },
    messages : {
    username : {
    required : "Please enter username"
    }
    }
    });


    $(document).ready(function () {
        $('.form-control').on('keyup', function () {
            $('.form-control').each(function (index) {
            if ($(this)[0].value !== '')
            $(this).parent().addClass('password_fild');
            else
            $(this).parent().removeClass('password_fild');
            });
        });
    });
    </script>
    </body>
    </html>
</fmt:bundle>
