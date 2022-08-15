function plotBox(box, line)

    opts = {"linewidth", 2};
    hold on
    plot(box.kVals([1,end]), box.lVals(1)*[1,1], line, opts{:});
    plot(box.kVals([1,end]), box.lVals(end)*[1,1], line, opts{:});
    plot(box.kVals(1)*[1,1], box.lVals([1,end]), line, opts{:});
    plot(box.kVals(end)*[1,1], box.lVals([1,end]), line, opts{:});
end