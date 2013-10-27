backend default {
    .host = "127.0.0.1";
    .port = "4567";
}

backend websocket {
    .host = "127.0.0.1";
    .port = "5556";
}

sub vcl_pipe {
     if (req.http.upgrade) {
         set bereq.http.upgrade = req.http.upgrade;
     }
}

sub vcl_recv {
     if (req.http.Upgrade ~ "(?i)websocket") {
        set req.backend = websocket;
        return (pipe);
     }
}

