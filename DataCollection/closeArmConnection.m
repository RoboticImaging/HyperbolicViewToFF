function closeArmConnection(socket)
    % Closes the TCPIP connection to the arm
    fclose(socket);
    fprintf('Connected to arm\n');
end