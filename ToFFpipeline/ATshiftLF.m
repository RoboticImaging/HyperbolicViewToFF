function newLF = ATshiftLF(LF, slope)
    LFSize = size(LF);
    newLF = zeros(LFSize);
    
    v = linspace(1,LFSize(3), LFSize(3));
    u = linspace(1,LFSize(4), LFSize(4));
    
    VOffsetVec = linspace(-0.5,0.5, LFSize(1)) *slope*LFSize(1);
    UOffsetVec = linspace(-0.5,0.5, LFSize(2)) *slope*LFSize(2);
    
    for( TIdx = 1:LFSize(1) )
	    VOffset = VOffsetVec(TIdx);
        for( SIdx = 1:LFSize(2) )
		    UOffset = UOffsetVec(SIdx);
		    CurSlice = squeeze(LF(TIdx, SIdx, :,:, :));
		    
		    Interpolant = griddedInterpolant( CurSlice );
		    Interpolant.Method = 'linear';
% 		    Interpolant.Method = 'nearest';
		    Interpolant.ExtrapolationMethod = 'nearest';
		    
		    CurSlice = Interpolant( {v+VOffset, u+UOffset} );
		    
		    newLF(TIdx,SIdx, :,:) = CurSlice;
        end
    end
end