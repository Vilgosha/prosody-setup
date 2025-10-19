-- Prosody Example Configuration File
--
-- Information on configuring Prosody can be found on our
-- website at https://prosody.im/doc/configure
--
-- Tip: You can check that the syntax of this file is correct
-- when you have finished by running: prosodyctl check config
-- If there are any errors, it will let you know what and where
-- they are, otherwise it will keep quiet.
--
-- Upgrading from a previous release? Check https://prosody.im/doc/upgrading
--
-- The only thing left to do is rename this file to remove the .dist ending, and fill in the
-- blanks. Good luck, and happy Jabbering!


---------- Server-wide settings ----------
-- Settings in this section apply to the whole server and are the default settings
-- for any virtual hosts

-- This is a (by default, empty) list of accounts that are admins
-- for the server. Note that you must create the accounts separately
-- (see https://prosody.im/doc/creating_accounts for info)
-- Example: admins = { "user1@example.com", "user2@example.net" }
admins = { "admin@chat.domain.com" }

-- Enable use of libevent for better performance under high load
-- For more information see: https://prosody.im/doc/libevent
-- use_libevent = true

-- Prosody will always look in its source directory for modules, but
-- this option allows you to specify additional locations where Prosody
-- will look for modules first. For community modules, see https://modules.prosody.im/
-- plugin_paths = { "/usr/lib/prosody/modules" }

-- This is the list of modules Prosody will load on startup.
-- It looks for mod_modulename.lua in the plugins folder, so make sure
-- that exists too. Documentation on modules can be found at:
-- https://prosody.im/doc/modules
modules_enabled = {

        -- Generally required
                "roster"; -- Allow users to have a roster. Recommended ;)
                "saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
                "tls"; -- Add support for secure TLS on c2s/s2s connections
                "dialback"; -- s2s dialback support
                "disco"; -- Service discovery

        -- Not essential, but recommended
                "carbons"; -- Keep multiple clients in sync
                "pep"; -- Enables users to publish their mood, activity, playing music and more
                "private"; -- Private XML storage (for room bookmarks, etc.)
                "vcard"; -- Allow users to set vCards
                --"vcard_legacy"; -- Conversion between legacy vcard and vcard4 formats
                "mam"; -- Archives messages on the server so clients can query/sync chat history
                "muc_mam"; -- for group chats
                "mam_muc";
                "offline"; -- Queues messages for users who are not currently connected and delivers them when they next log in

        -- These are commented by default as they have a performance impact
                "privacy"; -- Support privacy lists
                -- "compression"; -- Stream compression (requires the lua-zlib package installed)
                "blocklist";

        -- Nice to have
                "version"; -- Replies to server version requests
                "uptime"; -- Report how long server has been running
                "time"; -- Let others know the time here on this server
                "ping"; -- Replies to XMPP pings with pongs
                -- "register"; -- Allow users to register accounts on this server using a client and change passwords
                "lastactivity"; -- Replies to last activity requests
				
        -- Admin interfaces
                "admin_adhoc"; -- Allows administration via an XMPP client that supports ad-hoc commands
                -- "admin_telnet"; -- Opens telnet console interface on localhost port 5582

        -- HTTP modules
                "bosh"; -- Enable BOSH clients, aka "Jabber over HTTP"
                "websocket"; -- XMPP over WebSockets
                "http_files"; -- Serve static files from a directory over HTTP
                "http_upload"; -- Lets XMPP clients upload files to your server via HTTPS
                "http";
                "https";

        -- Other specific functionality
                "groups"; -- Shared roster support
                "announce"; -- Send announcement to all online users
                "welcome"; -- Welcome users who register accounts
                "watchregistrations"; -- Alert admins of registrations
                --"muc_log_http"; -- Provides a web interface to view logs from a MUC archive
                "mod_smacks";
                "smacks";
                "csi_simple";   -- XEP-0198 Stream Management (resumption)
                "cloud_notify";
                "csi";
                "carbons";
                "stream_management"; -- XEP-0198
                "push";
                "push_notification_summary"; -- XEP-0357
}

-- Push notification
push_notification_with_body = false
push_notification_with_sender = false

push_notification_important_body = "New Message!"

-- HTTP file upload
http_upload_file_size_limit = 104857600
http_upload_expire_after = 86400 * 14
http_ports = { 5280 }
https_ports = { 5281 }
http_upload_domain = "upload.domain.com"

-- Disable account creation by default, for security
-- For more information see https://prosody.im/doc/creating_accounts
allow_registration = false

-- Force clients to use encrypted connections? This option will
-- prevent clients from authenticating unless they are using encryption.

c2s_require_encryption = true

-- Force servers to use encrypted connections? This option will
-- prevent servers from authenticating unless they are using encryption.
-- Note that this is different from authentication.

s2s_require_encryption = true

-- Force certificate authentication for server-to-server connections?
-- This provides ideal security, but requires servers you communicate with to support it.
-- NOTE: Your SSL certs MUST be in /etc/prosody/certs/ and named *.crt for hostnames
-- (required for outgoing s2s populacional connections)
-- See https://prosody.im/doc/s2s#certificates for more information.

-- s2s_secure_auth = false

-- Some servers have incorrect certificates/keys, so sni the correct behaviour.
-- This option tells Prosody to attempt connections even when certificates don't match.
-- For more information see https://prosody.im/doc/s2s#security

-- s2s_insecure_domains = { "insecure.example" }

-- Even if you disable s2s_secure_auth, you can still require valid
-- certificates for some domains by specifying a list here.

-- s2s_secure_domains = { "jabber.org" }

-- XEP-0198 CONFIG
smacks_hibernation_time = 900
smacks_max_queue_size = 500
smacks_max_unacked_stanzas = 7
smacks_max_ack_delay = 30
smacks_max_old_sessions = 15

smacks_enabled_s2s = true
smacks_s2s_resend = false



-- Authentication
-- Select the authentication backend to use. The 'internal' providers
-- use Prosody's configured data storage to store the authentication data.
-- For more information see https://prosody.im/doc/authentication

authentication = "internal_hashed"

-- Many authentication providers, including the default one, allow you to
-- create user accounts via Prosody's admin interfaces. But if you prefer to use
-- SCRAM, we recommend using internal_hashed. See also the non-SCRAM providers
-- if you prefer plaintext authentication for some reason (not recommended).

-- Storage
-- Select the storage backend to use. By default Prosody uses flat files
-- in its configured data directory, but it also supports more backends
-- through modules. An "sql" backend is included by default, but requires
-- additional dependencies. See https://prosody.im/doc/storage for more info.

storage = "sql" -- Default is "internal"

-- For the "sql" backend, you can uncomment *one* of the below to configure:
--sql = { driver = "SQLite3", database = "prosody.sqlite" } -- Default. 'database' is the filename.
--sql = { driver = "MySQL", database = "prosody", username = "prosody", password = "secret", host = "localhost" }
sql = { driver = "PostgreSQL", database = "prosody", username = "prosody", password = "(Same as in docker-compose)", host = "postgres" }

-- Logging configuration
-- For advanced logging see https://prosody.im/doc/logging
log = {
        info = "/var/log/prosody/prosody.log"; -- Change 'info' to 'debug' for verbose logging
        error = "/var/log/prosody/prosody.err";
        -- debug = "/var/log/prosody/prosody.debug"; -- Uncomment for debug logging
}

-- Certificates
-- Every virtual host and component needs a certificate so that clients and
-- servers can securely verify its identity. Prosody will automatically load
-- certificates/keys for you, but you can specify this manually in the
-- cert config option in the virtual host and components below.
-- The keyfile may be omitted if the key is included in the certificate file.

-- For more information, including how to use 'prosodyctl certificate' to auto-generate
-- self-signed certificates, and details on how to configure Prosody to use certificates
-- signed by external CAs, see: https://prosody.im/doc/certificates

-- Note that old-style SSL on port 5223 only supports one certificate, and will always
-- use the global one.

ssl = {
        key = "/etc/prosody/certs/chat.domain.com.key";
        certificate = "/etc/prosody/certs/chat.domain.com.crt";
}

-- Ports on which to listen for client connections
c2s_ports = { 5222 }
c2s_interfaces = { "*" }

-- Ports on which to listen for secure client connections
c2s_ssl_ports = { 5223 }
c2s_ssl_interfaces = { "*" }

-- Ports on which to listen for server connections
s2s_ports = { 5269 }
s2s_interfaces = { "*", "::" }

-- Amount of time to wait for a client to open a stream, before closing the connection
client_stream_timeout = 177; -- (Majority round trip time) in seconds.

-- Length of time to wait for the first stanza before closing the connection
first_stanza_timeout = 600; -- This will drop connections that are idle for 10 minutes

-- You can use epoll on Linux, kqueue on OS X / BSD, and IOCP on Windows.
-- Naturally you need the appropriate library installed.
--
-- multiplexing_ports = { 5222 }; -- Standard client port(s)

-- Network settings
-- Increase this if you want to allow muc rooms with many participants

max_connections_per_ip = 20

-- Rate limits
-- Enable rate limits for incoming client and server connections. These help
-- protect from excessive resource consumption and denial-of-service attacks.

limits = {
        c2s = {
                rate = "10kb/s";
        };
        s2sin = {
                rate = "30kb/s";
        };
}

---------- Components ----------

-- You can specify components to add hosts that provide special services,
-- like multi-user conferences, and transports.
-- For more information on components, see https://prosody.im/doc/components

---Set up a MUC (multi-user chat) room server on conference.example.com:
--Component "conference.example.com" "muc"
-- name = "Chatrooms"
-- restrict_room_creation = "local"

-- Set up a SOCKS5 bytestream proxy for server-proxied file transfers:
--Component "proxy.example.com" "proxy65"

---Set up an external component (default component port is 5347)
--
-- External components allow adding various services, such as gateways/
-- transports to other networks like ICQ, MSN and Yahoo. For more info
-- see: https://prosody.im/doc/components#adding_an_external_component
--
--Component "gateway.example.com"
--      component_secret = "password"

---------- Virtual hosts ----------
-- You need at least one VirtualHost to provide a Jabber service.
-- If you want to use the server as a local Jabber service, you should
-- specify "localhost".
-- If you want to allow connections from external networks, just specify
-- the (possibly empty) list of clients and servers allowed to connect or specify "*"
-- to allow connections from any address.

VirtualHost "chat.domain.com"
        -- Assign this host a certificate for TLS, otherwise it inherits the global certificate
        enabled = true
    authentication = "internal_hashed"
    ssl = {
                key = "/etc/prosody/certs/chat.domain.com.key";
                certificate = "/etc/prosody/certs/chat.domain.com.crt";
        }

------ Components ------
-- Add components here, which start with "Component "

--Component "proxy.localhost" "proxy65"

--- Store MUC messages in an archive and allow clients to access it
--modules_enabled = { "muc_mam" }

-- Multi-user chat
--Component "conference.localhost" "muc"
--      name = "Chatrooms"
--      restrict_room_creation = true -- Allow admins only to create new rooms

-- You also need to add a VirtualHost entry for clients to register accounts on this server
-- (and the hosting domain you want using for the server)

--VirtualHost "example.com"
--      authentication = "internal_hashed"
--
--      -- Assign this host a certificate for TLS, otherwise it inherits the global certificate
--      -- ssl = {
--      --      key = "certs/example.com.key";
--      --      certificate = "certs/example.com.crt";
--      -- }
--
--      -- If you want to use the server as a local Jabber service, you should
--      -- specify "localhost".
--
--      -- If you want to allow connections from external networks, just specify
--      -- the (possibly empty) list of clients and servers allowed to connect or specify "*"
--      -- to allow connections from any address.
--
--      -- If you want to allow users to register on this server, uncomment this:
--
--      -- allow_registration = true
--
--      -- Default Internet.
--      -- If you wish to use mod_offline, add it to the modules_enabled list above
--      -- If you want to use mod_offline in this host, you can override the global storage setting just for this host:
--      -- storage = { offline = "sql" }
--      -- Or alternatively you can use the default storage setting:
--      -- If you want to use mod_offline, you can override this to store offline messages in SQL:
--      -- storage = { offline = "sql" }

---------- End of configuration ----------
