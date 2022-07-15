function socket =  openArmConnection(armIP,port)
    % Open a tcpip connection with the robotic arm at IP
    % address armIP ('129.78.214.100') and port (usually 30003)
    % send commands to arm using fprintf(socket,messageString)
    socket = tcpip(armIP, port); %note that the default role is client

    fopen(socket);
    fprintf('Connected to arm\n');
end