function closeArmConnection(socket)
    % Closes the TCPIP connection to the arm
    fclose(socket);
    fprintf('Disconnected from arm\n');
end