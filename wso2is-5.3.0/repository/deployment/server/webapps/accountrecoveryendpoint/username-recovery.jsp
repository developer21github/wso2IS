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
<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.IdentityManagementEndpointConstants" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.IdentityManagementEndpointUtil" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.ApiException" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.api.UsernameRecoveryApi" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.model.Claim" %>
<%@ page import="java.util.List" %>

<%
    if (!Boolean.parseBoolean(application.getInitParameter(
            IdentityManagementEndpointConstants.ConfigConstants.ENABLE_EMAIL_NOTIFICATION))) {
        response.sendError(HttpServletResponse.SC_FOUND);
        return;
    }

    boolean error = IdentityManagementEndpointUtil.getBooleanValue(request.getAttribute("error"));
    String errorMsg = IdentityManagementEndpointUtil.getStringValue(request.getAttribute("errorMsg"));

    boolean isFirstNameInClaims = false;
    boolean isLastNameInClaims = false;
    boolean isEmailInClaims = false;
    List<Claim> claims;
    UsernameRecoveryApi usernameRecoveryApi = new UsernameRecoveryApi();
    try {
        claims = usernameRecoveryApi.claimsGet(null);
    } catch (ApiException e) {
        request.setAttribute("error", true);
        request.setAttribute("errorMsg", e.getMessage());
        request.getRequestDispatcher("error.jsp").forward(request, response);
        return;
    }

    if (claims == null || claims.size() == 0) {
        request.setAttribute("error", true);
        request.setAttribute("errorMsg", "No recovery supported claims found");
        request.getRequestDispatcher("error.jsp").forward(request, response);
        return;
    }

    for (Claim claim : claims) {
        if (StringUtils.equals(claim.getUri(),
                IdentityManagementEndpointConstants.ClaimURIs.FIRST_NAME_CLAIM)) {
            isFirstNameInClaims = true;
        }
        if (StringUtils.equals(claim.getUri(), IdentityManagementEndpointConstants.ClaimURIs.LAST_NAME_CLAIM)) {
            isLastNameInClaims = true;
        }
        if (StringUtils.equals(claim.getUri(),
                IdentityManagementEndpointConstants.ClaimURIs.EMAIL_CLAIM)) {
            isEmailInClaims = true;
        }
    }

%>
<fmt:bundle basename="org.wso2.carbon.identity.mgt.endpoint.i18n.Resources">
    <html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Recover username - John Snow LABS</title>

        <link rel="icon" href="/images/favicon.png" type="image/x-icon"/>
        <link href="libs/bootstrap_3.3.5/css/bootstrap.min.css" rel="stylesheet">
        <link type="text/css" href="/font-awesome/css/font-awesome.min.css" rel="stylesheet">
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

    <!-- header -->
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
                        <h4 class="margin-none">Recover Username</h4>

                        <div class="login-form mailform">


                            <form method="post" action="verify.do" id="recoverDetailsForm">
                            <% if (error) { %>
                            <div class="alert alert-danger" id="server-error-msg">
                                <%= Encode.forHtmlContent(errorMsg) %>
                            </div>
                            <% } %>
                            <div class="alert alert-danger" id="error-msg" hidden="hidden"></div>
                                <% if (isFirstNameInClaims) { %>
                                <div class="form-group">
                                    <label class="mfInput">
                                        <input id="first-name"  type="text" name="first-name" class="form-control">
                                        <span class="help-block with-errors"></span>
                                        <span class="mfIcon">
                                            <span></span>
                                        </span>
                                        <span class="mfPlaceHolder">First Name </span>
                                    </label>
                                </div>
                                <%}%>

                                <% if (isLastNameInClaims) { %>
                                <div class="form-group">
                                    <label class="mfInput">
                                        <input id="last-name" type="text" name="last-name" class="form-control ">
                                        <span class="help-block with-errors"></span>
                                        <span class="mfIcon">
                                            <span></span>
                                        </span>
                                        <span class="mfPlaceHolder">Last Name </span>
                                    </label>
                                </div>
                                <%}%>

                                <%
                                    String callback = Encode.forHtmlAttribute
                                            (request.getParameter("callback"));

                                    if (StringUtils.isBlank(callback)) {
                                        callback = IdentityManagementEndpointUtil.getUserPortalUrl(
                                                application.getInitParameter(IdentityManagementEndpointConstants.ConfigConstants.USER_PORTAL_URL));
                                    }

                                    if (callback != null) {
                                %>
                                <div>
                                    <input type="hidden" name="callback" value="<%=callback %>"/>
                                </div>
                                <%
                                    }

                                 if (isEmailInClaims) { %>
                                <div class="form-group">
                                    <label class="mfInput">
                                        <input id="email" type="email" name="email" class="form-control" data-validate="email">
                                        <span class="help-block with-errors"></span>
                                        <span class="mfIcon">
                                            <span></span>
                                        </span>
                                        <span class="mfPlaceHolder">Email  </span>
                                    </label>
                                </div>
                                <%}%>

                                <div class="form-group">
                                    <label class="mfInput">
                                        <input type="text" id="tenant-domain" name="tenant-domain" class="form-control"/>
                                        <span class="help-block with-errors"></span>
                                        <span class="mfIcon">
                                            <span></span>
                                        </span>
                                        <span class="mfPlaceHolder">Tenant Domain  </span>
                                    </label>

                                </div>

                                <td>&nbsp;&nbsp;</td>
                                <input type="hidden" , id="isUsernameRecovery" , name="isUsernameRecovery" value="true">

                                <% for (Claim claim : claims) {
                                    if (claim.getRequired() &&
                                            !StringUtils.equals(claim.getUri(),
                                                    IdentityManagementEndpointConstants.ClaimURIs.FIRST_NAME_CLAIM) &&
                                            !StringUtils.equals(claim.getUri(),
                                                    IdentityManagementEndpointConstants.ClaimURIs.LAST_NAME_CLAIM) &&
                                            !StringUtils.equals(claim.getUri(),
                                                    IdentityManagementEndpointConstants.ClaimURIs.EMAIL_CLAIM)) {
                                %>
                                <div class="form-group">
                                    <label class="control-label"><%= Encode.forHtmlContent(claim.getDisplayName())%>
                                    </label>
                                    <input type="text" name="<%= Encode.forHtmlAttribute(claim.getUri()) %>"
                                           class="form-control"/>
                                </div>
                                <%
                                        }
                                    }
                                %>

                                <div class="form-group text-center">
                                    <button id="recoverySubmit" class="btn btn-default" type="submit">Submit</button>
                                </div>
                                <%--<div class="form-actions">--%>
                                    <%--<table width="100%" class="styledLeft">--%>
                                        <%--<tbody>--%>
                                        <%--<tr class="buttonRow">--%>
                                            <%--<td>--%>
                                                <%--<button id="recoverySubmit"--%>
                                                        <%--class="wr-btn grey-bg col-xs-12 col-md-12 col-lg-12 uppercase font-extra-large"--%>
                                                        <%--type="submit">Submit--%>
                                                <%--</button>--%>
                                            <%--</td>--%>
                                            <%--<td>&nbsp;&nbsp;</td>--%>
                                            <%--<td>--%>
                                                <%--<button id="recoveryCancel"--%>
                                                        <%--class="wr-btn grey-bg col-xs-12 col-md-12 col-lg-12 uppercase font-extra-large"--%>
                                                        <%--type="button"--%>
                                                        <%--onclick="location.href='<%=Encode.forJavaScript(IdentityManagementEndpointUtil.getUserPortalUrl(--%>
                                                            <%--application.getInitParameter(IdentityManagementEndpointConstants.ConfigConstants.USER_PORTAL_URL)))%>';">--%>
                                                    <%--Cancel--%>
                                                <%--</button>--%>
                                            <%--</td>--%>
                                        <%--</tr>--%>
                                        <%--</tbody>--%>
                                    <%--</table>--%>
                                <%--</div>--%>
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
    <script src=js/jquery.validate.js></script>
    <script src=js/validate.js></script>
    <script>
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
