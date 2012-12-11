function TwitterConnect () {

    this.exec = function (url) {
        var self = this,
            params = 'location=0,status=0,width=800,height=600';

        this.twitter_window = window.open(url, 'twitterWindow', params);

        this.interval = window.setInterval((function () {
            if (self.twitter_window.closed) {
                window.clearInterval(this.interval);
                this.finish();
            }
        }), 1000);

        // the server will use this cookie to determine if the Twitter redirection
        // url should window.close() or not
        document.cookie = 'twitter_oauth_popup=1; path=/';
    }

   this.finish = function () {
        $.ajax({
            type:'get',
            url:'/auth/check/twitter',
            dataType:'json',
            success:function (response) {
                if (response.authed) {
                    this.twitter_window.close()

                } else {
                    this.twitter_window.close()

                }
            }
        });
    };


}


twitconnect = new TwitterConnect()
