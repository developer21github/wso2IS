
// login form validation
$("#recoverDetailsForm").validate({
    rules : {
        "first-name" : {
            required : true
        },
        "last-name" : {
            required : true
        },
        "email" : {
            required : true
        },
        "tenant-domain" : {
            required : true
        }
    },
    messages : {
        "first-name" : {
            required : "Please enter first name"
        },
        "last-name" : {
            required : "Please enter last name"
        },
        "email" : {
            required : "Please enter email"
        },
        "tenant-domain" : {
            required : "Please enter tenant domain"
        }
    }
});

// recovery password validation

$("#register").validate({
    rules : {
        firstName : {
            required : true
        },
        lastName : {
            required : true
        },
        username : {
            required : true
        },
        email : {
            required : true
        },
        password : {
            required : true
        },
        password2 : {
            required : true
        }
    },
    messages : {
        firstName : {
            required : "Please enter first name"
        },
        lastName : {
            required : "Please enter last name"
        },
        email : {
            required : "Please enter email"
        },
        username : {
            required : "Please enter username"
        },
        password : {
            required : "Please enter password"
        },
        password2 : {
            required : "Please enter confirm password"
        }
    }
});

