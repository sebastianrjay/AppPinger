class AppPinger::Error < RuntimeError

class InvalidURLError < AppPinger::Error
end

class InvalidStartTimeError < AppPinger::Error
end
