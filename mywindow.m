function b = mywindow(varargin) 
narginchk(3,Inf)

a = varargin{1};

if ischar(varargin{2}) && strcmpi(varargin{2},'indexed')
    indexed = 1;        % It's an indexed image
    varargin(2) = [];
else
    indexed = 0;
end

if nargin==4,
    % COLFILT(A, [m n], kind, fun)
    a = varargin{1};
    block = mybestblk(size(a));
    nhood = varargin{2};
    kind = varargin{3};
    fun = varargin{4};    
    params = cell(0,0);    
end


fun = fcnchk(fun, length(params));

if ~ischar(kind),
    error(message('images:colfilt:invalidBlockType'));
end

kind = [lower(kind) ' ']; % Protect against short string
        
if kind(1)=='s', % Sliding
    if all(block>=size(a)), % Process the whole matrix at once.
  lpad = 0;
          mpad = 2*floor(nhood(2)/2);
          npad = 2*floor(nhood(3)/2);
        
        if indexed && isa(a, 'double'),
            aa = ones(size(a) + [lpad mpad npad ] + (nhood-1));
        else
%             aa = repmat(feval(class(a), 0),size(a) + [mpad npad lpad] + (nhood-1));
              aa = repmat(feval(class(a), 0),size(a) + [lpad mpad npad ] );
        end       
        aa(:,(npad/2+1):1:(size(a,2)+npad/2),(mpad/2+1):1:(size(a,3)+mpad/2))=a; 
%         test(:,:)=aa(1,:,:);
        for i=1:1:size(a,2),
            for j=1:1:size(a,3)
                chunk=aa(:,i:1:i+nhood(2)-1,j:1:j+nhood(3)-1);
                  b(i,j)=feval(fun,chunk,nhood);
            end
        end 
        
    else % Process the matrix in blocks of size BLOCK.
          lpad = 0;
          mpad = 2*floor(nhood(2)/2);
          npad = 2*floor(nhood(3)/2);
        
        if indexed && isa(a, 'double'),
            aa = ones(size(a) + [lpad mpad npad ] + (nhood-1));
        else
%             aa = repmat(feval(class(a), 0),size(a) + [mpad npad lpad] + (nhood-1));
              aa = repmat(feval(class(a), 0),size(a) + [lpad mpad npad ] );
        end       
        aa(:,(npad/2+1):1:(size(a,2)+npad/2),(mpad/2+1):1:(size(a,3)+mpad/2))=a; 
%         test(:,:)=aa(1,:,:);
        for i=1:1:size(a,2),
            for j=1:1:size(a,3)
                chunk=aa(:,i:1:i+nhood(2)-1,j:1:j+nhood(3)-1);
                  b(i,j)=feval(fun,chunk,nhood);
            end
        end      
    end
else
    error(message('images:colfilt:unknownBlockType', deblank(kind)));
end