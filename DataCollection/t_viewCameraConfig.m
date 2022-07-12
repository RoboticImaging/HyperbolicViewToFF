% Get the camera configuration file on the camera, and write it to disk.

serial = '201000b';
config_file = serial + "_config.bin";

cam = tof.GigeInterface();
msg = cam.find(serial);
cam.connect(msg);

config = cam.downloadConfiguration();
cam.disconnect();


print_configuration(config)