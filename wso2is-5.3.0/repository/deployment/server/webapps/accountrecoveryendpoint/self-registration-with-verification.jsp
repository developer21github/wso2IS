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

<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.apache.cxf.jaxrs.impl.ResponseImpl" %>
<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.IdentityManagementEndpointConstants" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.IdentityManagementEndpointUtil" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.ApiException" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.api.UsernameRecoveryApi" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.model.*" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.model.Error" %>

<%
    boolean error = IdentityManagementEndpointUtil.getBooleanValue(request.getAttribute("error"));
    String errorMsg = IdentityManagementEndpointUtil.getStringValue(request.getAttribute("errorMsg"));

    boolean isFirstNameInClaims = true;
    boolean isFirstNameRequired = true;
    boolean isLastNameInClaims = true;
    boolean isLastNameRequired = true;
    boolean isEmailInClaims = true;
    boolean isEmailRequired = true;
    int id= 0;

    Claim[] claims = new Claim[0];

    List<Claim> claimsList;
    UsernameRecoveryApi usernameRecoveryApi = new UsernameRecoveryApi();
    try {
        claimsList = usernameRecoveryApi.claimsGet(null);
        if (claimsList != null) {
            claims = claimsList.toArray(new Claim[claimsList.size()]);
        }
        IdentityManagementEndpointUtil.addReCaptchaHeaders(request, usernameRecoveryApi.getApiClient().getResponseHeaders());

    } catch (ApiException e) {
        Error errorD = new Gson().fromJson(e.getMessage(), Error.class);
        request.setAttribute("error", true);
        if (errorD != null) {
            request.setAttribute("errorMsg", errorD.getDescription());
            request.setAttribute("errorCode", errorD.getCode());
        }

        request.getRequestDispatcher("error.jsp").forward(request, response);
        return;
    }
%>
<%
    boolean reCaptchaEnabled = false;
    if (request.getAttribute("reCaptcha") != null && "TRUE".equalsIgnoreCase((String) request.getAttribute("reCaptcha"))) {
        reCaptchaEnabled = true;
    }
%>
<fmt:bundle basename="org.wso2.carbon.identity.mgt.endpoint.i18n.Resources">
    <html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Register - John Snow LABS</title>

        <link rel="icon" href="/images/favicon.png" type="image/x-icon"/>
        <link type="text/css" href="libs/bootstrap_3.3.5/css/bootstrap.min.css" rel="stylesheet">
        <link type="text/css" href="/font-awesome/css/font-awesome.min.css" rel="stylesheet">
        <link type="text/css" href="css/Roboto.css" rel="stylesheet">
        <link type="text/css" href="/css/style.css" rel="stylesheet">
    <style>
    .error{
    color:red !important;
    }
    </style>
        <!--[if lt IE 9]>
        <script src="js/html5shiv.min.js"></script>
        <script src="js/respond.min.js"></script>
        <![endif]-->
        <%
            if (reCaptchaEnabled) {
        %>
        <script src='<%=(request.getAttribute("reCaptchaAPI"))%>'></script>
        <%
            }
        %>
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
                        <h4 class="margin-none">Sign-Up to John Snow LABS</h4>
                        <div class="register-form mailform">
                            <form action="processregistration.do" method="post" id="register">
                                <% if (error) { %>
                                <div class="alert alert-danger" id="server-error-msg">
                                    <%= Encode.forHtmlContent(errorMsg) %>
                                </div>
                                <% } %>

                                <div class="alert alert-danger" id="error-msg" hidden="hidden">
                                </div>

                                <!-- validation -->
                                <div class="row">
                                    <div id="regFormError" class="alert alert-danger" style="display:none"></div>
                                    <div id="regFormSuc" class="alert alert-success" style="display:none"></div>

                                    <% if (isFirstNameInClaims) { %>
                                    <div class="col-xs-12 col-sm-6 form-group">
                                        <label class="mfInput">
                                            <input type="text" id="firstName" name="firstName" tabindex="0" class="form-control" <% if (isFirstNameRequired) {%> required <%}%>>
                                            <span class="mfIcon">
                                                <span></span>
                                            </span>
                                            <span class="mfPlaceHolder">First Name  </span>
                                        </label>
                                    </div>
                                    <%}%>

                                    <% if (isLastNameInClaims) { %>
                                    <div class="col-xs-12 col-sm-6 form-group">
                                        <label class="mfInput">
                                            <input type="text" id="lastName" name="lastName" class="form-control" <% if (isLastNameRequired) {%> required <%}%>/>
                                            <span class="mfIcon">
                                                <span></span>
                                            </span>
                                            <span class="mfPlaceHolder">Last Name  </span>
                                        </label>
                                    </div>
                                    <%}%>

                                    <div class="col-xs-12 col-sm-12 form-group required">
                                        <label class="mfInput">
                                            <input id="username" name="username" type="text"
                                               class="form-control required usrName usrNameLength" required>
                                            <span class="mfIcon">
                                               <span></span>
                                            </span>
                                            <span class="mfPlaceHolder">Username </span>
                                        </label>
                                    </div>


                                    <% if (isEmailInClaims) { %>
                                    <div class="col-xs-12 col-sm-12 form-group">
                                        <label class="mfInput">
                                            <input type="email" id="txtEmail" name="email" class="form-control" pattern="/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/" <% if (isEmailRequired) {%> required <%}%>>
                                            <span class="mfIcon">
                                                <span></span>
                                            </span>
                                            <span class="mfPlaceHolder">Email  </span>
                                        </label>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 form-group">
                                        <label class="mfInput">
                                            <input id="password" name="password" type="password" class="form-control" autocomplete="off" required>
                                            <span class="mfIcon">
                                                <span></span>
                                            </span>
                                            <span class="mfPlaceHolder">Password</span>
                                        </label>
                                    </div>

                                    <div class="col-xs-12 col-sm-12 form-group">
                                        <label class="mfInput">
                                            <input id="password2" name="password2" type="password" class="form-control" data-match="reg-password" required>
                                            <span class="mfIcon">
                                                <span></span>
                                            </span>
                                            <span class="mfPlaceHolder">Confirm password</span>
                                        </label>
                                    </div>
                                    <%
                                        }

                                        String callback = Encode.forHtmlAttribute
                                                (request.getParameter("callback"));
                                        if (StringUtils.isBlank(callback)) {
                                            callback = IdentityManagementEndpointUtil.getUserPortalUrl(
                                                    application.getInitParameter(IdentityManagementEndpointConstants.ConfigConstants.USER_PORTAL_URL));
                                        }

                                        if (callback != null) {
                                    %>
                                    <div class="col-xs-12 col-sm-12 required">
                                        <input type="hidden" name="callback" value="<%=callback %>"/>
                                    </div>
                                    <div class="">
                                        <%
                                            }

                                            for (Claim claim : claims) {
                                            if (!StringUtils.equals(claim.getUri(),
                                                    IdentityManagementEndpointConstants.ClaimURIs.FIRST_NAME_CLAIM) &&
                                                !StringUtils.equals(claim.getUri(), IdentityManagementEndpointConstants.ClaimURIs.LAST_NAME_CLAIM) &&
                                                !StringUtils.equals(claim.getUri(), IdentityManagementEndpointConstants.ClaimURIs.EMAIL_CLAIM) &&
                                                !StringUtils.equals(claim.getUri(), IdentityManagementEndpointConstants.ClaimURIs.CHALLENGE_QUESTION_URI_CLAIM) &&
                                                !StringUtils.equals(claim.getUri(), IdentityManagementEndpointConstants.ClaimURIs.CHALLENGE_QUESTION_1_CLAIM) &&
                                                !StringUtils.equals(claim.getUri(), IdentityManagementEndpointConstants.ClaimURIs.CHALLENGE_QUESTION_2_CLAIM)) {
                                        %>

                                        <div class="col-xs-12 col-sm-6 form-group form-input-group">
                                            <label class="mfInput" <% if (claim.getRequired()) {%> class="control-label" <%}%>>
                                                <input type="text" id="<%= Encode.forHtmlAttribute(claim.getUri()) %>" name="<%= Encode.forHtmlAttribute(claim.getUri()) %>" class="form-control" <% if (claim.getRequired()) {%> required <%}%>>
                                                <span class="mfIcon">
                                                    <span></span>
                                                </span>
                                                <span class="mfPlaceHolder"><%= Encode.forHtmlContent(claim.getDisplayName())%></span>
                                            </label>
                                        </div>

                                        <%
                                                }
                                            }
                                        %>
                                    </div>
                                    <%
                                        if (reCaptchaEnabled) {
                                    %>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 form-group">
                                        <div class="g-recaptcha"
                                             data-sitekey="<%=Encode.forHtmlContent((String)request.getAttribute("reCaptchaKey"))%>">
                                        </div>
                                    </div>
                                    <%
                                        }
                                    %>
                                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                        <input id="isSelfRegistrationWithVerification" type="hidden"
                                               name="isSelfRegistrationWithVerification"
                                               value="true"/>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 form-group">
                                        <small class="h6">Already have an account? </small>
                                        <a href="<%=Encode.forHtmlAttribute(IdentityManagementEndpointUtil.getUserPortalUrl(
                                           application.getInitParameter(IdentityManagementEndpointConstants.ConfigConstants.USER_PORTAL_URL)))%>"
                                           id="signInLink" class="font-large"><small class="h6">Sign in</small></a>
                                    </div>
                                    <div class="col-xs-12 col-sm-12 form-group text-center">
                                        <button id="registrationSubmit" class="btn btn-default" type="submit">Sign Up</button>
                                    </div>

                                    <div class="clearfix"></div>
                                </div>
                            </form>
                            <div class="btn-group btn-group-justified">
                                <div class="btn-group" role="group">
                                    <a class="btn btn-lg btn-facebook"><i class="ico-facebook"></i> Sign up with Facebook</a>
                                </div>
                                <div class="btn-group" role="group">
                                    <a class="btn btn-lg btn-google"><i class="ico-google"></i> Sign up with Google</a>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <!-- /content/body -->
        </div>

        <!-- footer -->
        <footer class="footer text-center">
        <div class="container">
    <p><script>document.write(new Date().getFullYear());</script> <a href="http://wso2.com/" target="_blank"><i class="fw fw-wso2"></i> Inc</a>. All Rights Reserved.</p>
        </div>
        </footer>
    </div>
    <script src="/js/jquery-3.2.1.min.js"></script>
    <script src="libs/bootstrap_3.3.5/js/bootstrap.min.js"></script>
    <script src="js/jquery.validate.js"></script>
    <script src="js/validate.js"></script>

    <script type="text/javascript">

        $(document).ready(function () {

            $("#register").submit(function (e) {

                var password = $("#password").val();
                var password2 = $("#password2").val();
                var error_msg = $("#error-msg");

                if (password != password2) {
                    error_msg.text("Passwords did not match. Please try again.");
                    error_msg.show();
                    $("html, body").animate({scrollTop: error_msg.offset().top}, 'slow');
                    return false;
                }

                return true;
            });
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


