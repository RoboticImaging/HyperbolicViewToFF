function fn = poissonPDF(lambda)
    sigma = sqrt(lambda);
    fn = @(x) 1/(sqrt(2*pi)*sigma)*exp(-0.5*((x-lambda)/sigma).^2);
end