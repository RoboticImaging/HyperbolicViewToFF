function save2pdf(figHandle, fname)
    set(figHandle,'Renderer','Painter')
    set(figHandle,'Units','Inches');
    pos = get(figHandle,'Position');
    set(figHandle,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(figHandle,fname,'-dpdf','-r0')
end