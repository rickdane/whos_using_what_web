poll_for_login_status = function (interval) {

    $.ajax({
        url:'/loginstatus',
        success:function (resp) {
            if (resp == true) {
                interval = null
                document.location = "/searches/new"
            }
        },
        dataType:'json'
    });

}

var polling_interval = 5000

function AuthenticationPopup() {

    this.exec = function (url) {
        var self = this,
            params = 'location=0,status=0,width=400,height=600';

        window.open(url, 'authenticationPopup', params);

        interval = window.setInterval((function () {

            poll_for_login_status(interval)

        }), polling_interval);

        jaaulde.utils.cookies.set('authentication_popup', true);
    }


}


authenticationPopup = new AuthenticationPopup()

var auth_popup_cookie = jaaulde.utils.cookies.get('authentication_popup');

if (auth_popup_cookie != null && auth_popup_cookie) {

    jaaulde.utils.cookies.set('authentication_popup', false);

    window.close()

}
