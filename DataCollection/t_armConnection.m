clear
clc


HOST = '172.17.7.82';
PORT_30003 = 30003;
arm = openArmConnection(HOST, PORT_30003);

n = [0;1;0];
n = n./norm(n);

pos = [500 -15  350]./1000;


x = 1/sqrt(2)*[1;-1;0];
y = 1/sqrt(2)*[1;1;0];
RglobalToDefault = [x,y,[0;0;1]];

RglobalToDesired = [0 1 0;
                                  0 0 1;
                                  1 0 0];

RDefaultToDesired = RglobalToDesired*RglobalToDefault';

orientationVec = vrrotmat2vec(RDefaultToDesired);
orientationVec = orientationVec(1:3)*orientationVec(4);


movePose(arm, pos, orientationVec)

closeArmConnection(arm)
