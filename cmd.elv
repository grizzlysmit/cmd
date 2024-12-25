use str
use os
use path
use builtin

fn executable {|path|
    if ?(e:test -x $path) {
        put $true
    } else {
        put $false
    }
}

fn command-exists {|cmd|
    if (and (path:is-abs $cmd) (os:is-regular &follow-symlink=$true $cmd) (eq (executable $cmd) $true)) {
        put $true
    } else {
        for p $paths {
            if (and (os:is-regular &follow-symlink=$true $p'/'$cmd) (eq (executable $p'/'$cmd) $true)) {
                put $true
                return
            }
        } else {
            put $false
            return
        }
        put $false
        return
    }
}

fn not-a-function {|cmd|
    if (==s (resolve $cmd) '$'$cmd'~') {
        put $true
    } else {
        put $true
    }
}

fn command_not_found {|cmd|
    if (not (==s $cmd '')) {
        var args = [(str:fields $cmd)]
        var arg0  =  $args[0]
        var res   = (builtin:resolve $arg0)
        #put '$arg0 == '$arg0
        #put '$res == '$res
        if (or (==s $res '$'$arg0'~') (==s $res 'special')) {
        } elif (not (and (==s $res '(external '$arg0')') (eq (builtin:has-external $arg0) $true))) {
            e:cmd-not-found --no-failure-msg -- $arg0
        }
    }
}

