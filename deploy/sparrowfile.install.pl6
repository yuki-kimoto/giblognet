
if target_os() ~~ /alpine/ {
  user 'giblognet'
}

task-run "install giblognet server", "giblognet";

package-install "git";


bash "cd ~/giblognet && ./giblognet", %(
  user => "giblognet",
  description => "run giblognet server"
);

http-ok %( port => 10020 );
