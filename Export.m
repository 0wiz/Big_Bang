function Export(Film, Name, Ext, Delay)
file = join([Name '.' Ext]);
frames = numel(cellfun('isempty',{Film.cdata}));
switch Ext
    case 'gif'
        for f = 1:frames
            % Convert format
            image = frame2im(Film(f)); 
            [i,c] = rgb2ind(image,256); 

            % Write to the GIF File
            if f == 1, imwrite(i,c,file,'gif','Loopcount',inf,'DelayTime',Delay); 
            else, imwrite(i,c,file,'gif','WriteMode','append','DelayTime',Delay); 
            end
        end
    case 'avi'
        v = VideoWriter(file);
        open(v)
        for f = 1:frames, writeVideo(v,Film(f)), end
        close(v)
end