local socket = require "socket"
local kcplib = {}

function kcplib.send(id, from, data)
	socket.sendto(id, from, data)
end

return kcplib
