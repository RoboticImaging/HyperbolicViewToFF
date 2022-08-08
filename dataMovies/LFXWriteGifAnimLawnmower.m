% todo: doc

function LFXWriteGifAnimLawnmower( LF, FName, NFrames, DelayTime, ResizeRatio )

%---Defaults---
NFrames = LFDefaultVal( 'NFrames', 24 );
DelayTime = LFDefaultVal( 'DelayTime', 1/24 );
ResizeRatio = LFDefaultVal( 'ResizeRatio', 1 );

%---Check for mono and clip off the weight channel if present---
Mono = (ndims(LF) == 4);
if( ~Mono )
    LF = LF(:,:,:,:,1:3);
end

%---Rescale for 8-bit display---
if( isfloat(LF) )
    LF = uint8(LF ./ max(LF(:)) .* 255);
else
    LF = uint8(LF.*(255 / double(intmax(class(LF)))));
end


%---Setup the motion path---
[TSize,SSize, ~,~] = size(LF(:,:,:,:,1));
[tt,ss] = ndgrid(1:TSize, 1:SSize);



WriteMode = 'overwrite';


dLFmax = max(LF,[],"all");

FirstPass = true;

% left/right
TVec = tt;
SVec = ss;
SVec(2:2:end,:) = SVec(2:2:end,end:-1:1);
SVec = SVec';
TVec = TVec';

for( PoseIdx = 1:numel(tt) )
	
	TIdx = TVec(PoseIdx);
	SIdx = SVec(PoseIdx);
	
	CurFrame =  squeeze(LF( TIdx, SIdx, :,:,: ));
	
    if ( FirstPass )
        imwrite(CurFrame,FName,'gif', 'Loopcount',inf, 'DelayTime',DelayTime, 'WriteMode',WriteMode);
        WriteMode = 'append';
        FirstPass = false;
    else
        imwrite(CurFrame,FName,'gif', 'DelayTime',DelayTime, 'WriteMode',WriteMode);
    end
    fprintf('.')
	
end

% Up/down
TVec = tt;
TVec(:,2:2:end) = TVec(end:-1:1, 2:2:end);
SVec = ss;

for( PoseIdx = 1:numel(tt) )
	
	TIdx = TVec(PoseIdx);
	SIdx = SVec(PoseIdx);
	
	CurFrame =  squeeze(LF( TIdx, SIdx, :,:,: ));
	
    imwrite(CurFrame,FName,'gif', 'DelayTime',DelayTime, 'WriteMode',WriteMode);
    fprintf('.')
	
end
fprintf(' Done\n');

