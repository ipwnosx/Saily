// Do not upload this to git.

import UIKit
import Foundation

// We communicate with daemon over web socket over a random port in range 2333...6666
// auth session_token is an identity ensure the app is running only once
// while session_port is an identify ensure the daemon could find somewhere to read

// Daemon will always accept the infomation of session_port while not session_token
// If our daemon has read a session_token which is differently from exists, 
//    daemon woud send back message "Invalid session_token" and then restart.

// We will first build up http server for token sure. It's not encoded
// at 127.0.0.1:session_port/session.token

// Then, later,
// We will send session_port over notify(), yes because I don't want to use XPC cause there might be future mergition, 
//    notify("com.Saily.session.init.start_read_port")
//    notify("com.Saily.session.init.addport.0")
//    notify("com.Saily.session.init.addport.1")
//    notify("com.Saily.session.init.addport.2")
//    notify("com.Saily.session.init.addport.3")
//    notify("com.Saily.session.init.addport.4")
//    notify("com.Saily.session.init.addport.5")
//    notify("com.Saily.session.init.addport.6")
//    notify("com.Saily.session.init.addport.7")
//    notify("com.Saily.session.init.addport.8")
//    notify("com.Saily.session.init.addport.9")
//    notify("com.Saily.session.init.end_read_port")

// When notify("com.Saily.session.init.end_read_port") called to daemon,
//   our daemon will immediately read from 127.0.0.1:session_port/session.token to look for session token
//   if we are not able to find a token, daemon will exit for restart. (not reboot)

// Then our daemon will read message from 127.0.0.1:session_port/job_quene
// When notify("com.Saily.session.submit_job_quene")

class saily_daemon_auth_session_AppSide {

    var session_token = ""
    var session_port  = 0
    
    func bootstrap() -> Void {
        ensure_token()
        ensure_port()
    }

    func ensure_token() -> Void {
        if (session_token == "") {
            session_token = UUID().uuidString
            print("[*] Session_token init_ed! :" + session_token)
        }else{
            print("[E] Double init of session_token.")
        }
    }

    func ensure_port() -> Void {
        if (session_port == 0) {
            session_port = Int.random(in: 2333...6666)
            print("[*] Session_port init_ed! :" + session_port.description)
        }else{
            print("[E] Double init of session_port.")
        }
    }

    func auth_with_daemon() -> Void {
        
    }
    
    func tell_demon_to_listen_at_port() -> Void {

    }

}
