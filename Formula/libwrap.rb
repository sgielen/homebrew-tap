require "formula"

class Libwrap < Formula
  homepage "ftp://ftp.porcupine.org/pub/security/index.html"
  url "ftp://ftp.porcupine.org/pub/security/tcp_wrappers_7.6.tar.gz"
  sha1 "61689ec85b80f4ca0560aef3473eccd9e9e80481"

  # Fix code compilation error
  patch :DATA

  def install
    system "chmod +w Makefile"
    system "echo 'cflags:' >>Makefile"
    system "make REAL_DAEMON_DIR=/usr/sbin freebsd"
    system "make libwrap.a"
    bin.install "safe_finger"
    bin.install "tcpd"
    bin.install "tcpdchk"
    bin.install "tcpdmatch"
    bin.install "try-from"
    lib.install "libwrap.a"
  end
end
__END__
diff --git a/fix_options.c b/fix_options.c
index b5e81b8..c530e1e 100644
--- a/fix_options.c
+++ b/fix_options.c
@@ -82,7 +82,7 @@ struct request_info *request;
 		   "refused connect from %s with IP source routing options",
 		       eval_client(request));
 		shutdown(fd, 2);
-		return;
+		return NULL;
 	    }
 	    if (opt == IPOPT_EOL)
 		break;
