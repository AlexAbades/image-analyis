classdef CameraGeometry
    %CameraGeometry Class that calculates how objects are captured in a
    %specific image, with a specific CCD and specific focal distance.
    %   Once you create an instace of the class, having passed the focal
    %   length dictance (f), the distance from the object to the lent (g),
    %   the image dimension (I) and the CCD dimension (CCD). It will
    %   calculate the intersection distance (b) the pixel dimension (P).
    %   You will be able to call some methods to calculate the FOV, the
    %   size of an captured object on CCD and the opposite.
    
    properties
        % Focal distance in mm.
        f                {mustBePositive, mustBeNonzero, mustBeFinite}
        % Image dimensions (y,x) in pixels.
        I (1,2)         %{mustBePositive, mustBeNonzero, mustBeFinite} How can I specify positive numbers on vectors
        % CCD-chip dimensions (x,y) in mm.
        CCD (1,2)       %{mustBePositive, mustBeNonzero, mustBeFinite}
        % Distance to intersection. Where CCD is placed. In mm.
        b                {mustBePositive, mustBeNonzero, mustBeFinite}
        % Object distance. Must be in mm.
        g                {mustBePositive, mustBeNonzero, mustBeFinite}
        % Pixel dimensions in mm. (x,y) Coordinate system
        P (1,2)         %{mustBePositive, mustBeNonzero, mustBeFinite}
        
        
    end
    methods (Static) 
        
        function b = CameraBDistance(f, g)
            %CameraBDistamce(f,g): Returns the distance to the 
            % intersection. It's also where the CCD it's placed.
            %   Arguments:
            %   f-> Focal length distance.
            %   g-> Object distance. Must be in mm.                       
            arguments
                f (1,:) {mustBePositive, mustBeNonzero, mustBeFinite}
                % f: Focal length distance.
                g (1,:) {mustBePositive, mustBeNonzero, mustBeFinite}
                % g: Object distance. Must be in mm.
            end

            b = (f*g)/(g-f);
            
        end
        
        function P = PixelDimension(I,CCD)
            %PixelDimension(I,CCD) Returns the CCD pixels dimension in
            %mm.
            %   Arguments:
            %   I-> Image dimensions in image format. (col,row) 
            %   CCD -> CCD dimensions in mm. (x,y)
            arguments
                I (1,2)  {mustBePositive, mustBeNonzero, mustBeFinite}
                % Image size in image format. (WIDTH x HEIGHT) (columns x
                % rows) or (y,x). As opposite as a matrix dimensions.
                CCD (1,2)  {mustBePositive, mustBeNonzero, mustBeFinite}
                % CCD Dimensions in mm.
            end
            
            P(1,1) = (CCD(1,1)/I(1,1)); % Pixel x distance in mm.
            P(1,2) = (CCD(1,2)/I(1,2)); % Pixel y distance in mm.
            
        end
        
        function angle = calcangle(a, b)
            %calcangle(a,b) Returns the angle between two sidesCCD pixels dimension in
            %mm.
            %   Arguments: (both must have same dimension)
            %   a-> Value of the adjacent side. 
            %   b -> Value of the opposite side.
            arguments
                a (1,:) {mustBePositive, mustBeNonzero, mustBeFinite}
                % Value of the adjacent side.
                b (1,:) {mustBePositive, mustBeNonzero, mustBeFinite}
                % Value of the opposite side.
            end
            
            angle = atand(b/a);
            
        end
              
    end
    
    methods
        function obj = CameraGeometry(g,f,I, CCD)
            %CameraGeometry Construct an instance of this class.
            %   Arguments:
            %   g-> Object distance. Must be in mm.
            %   f-> Focal distance in. Must be mm.
            %   I-> Image dimensions (y,x) in pixels.
            %   CCD-> CCD-chip dimensions (x,y) in mm.
            obj.f = f;
            obj.I = I;
            obj.CCD = CCD;
            obj.g = g;
            obj.b = obj.CameraBDistance(f, g);
            obj.P = obj.PixelDimension(I, CCD);
            
        end
        
        function FOV =CameraFOV(obj)
            %CameraFOV Returns the field of view. 
            %   FOV-> Is a vector where stores the angles Alpha and Beta.
            %   Alpha: Horizontal angle in degres
            %   Beta: Vertical angle in degrees
                     
            FOV(1,1) = calcangle(obj.b, (obj.CCD(1,1)/2));
            FOV(1,2) = calcangle(obj.b, (obj.CCD(1,2)/2));
            
        end
        
        function [B] = RealSizeOnCCD(obj,G)
            %RealSizeOnCCD(G) Returns the object height on the CCD in mm. 
            %   Arguments: 
            %   G-> Object height in mm.
            arguments
                obj
                % Object itself
                G (1,:) {mustBePositive, mustBeNonzero, mustBeFinite}
                % Object height in mm.
            end
            
            B = (obj.b*G)/obj.g;
        end
        
        function [N] = PixelSizeOnCCD(obj, G)
            %PixelSizeOnCCD(G): Returns the hight of a given object in 
            %pixels.           
            %   Arguments:
            %   G-> Object height in real life.
            arguments
                obj
                % Object distance from les (camera)                
                G (1,1) {mustBePositive, mustBeNonzero, mustBeFinite}
                % Object heighti in real life.                
            end
            
            % Calculate the height on CCD in mm.
            B = RealSizeOnCCD(obj.f, G);            
            % Number of pixels that the CCD needs to capture the object
            N =  B/obj.P(1,2);
            
        end
        
        function [H] = CCDtoReal(obj, B)
            %CCDtoReal: Returns the height in Real life given the height
            %on CCD
            %   Arguments:
            %   B-> Height of the object in CCD. Must be in mm.            
            arguments
                obj
                % Object distance from les (camera)                
                B (1,1) {mustBePositive, mustBeNonzero, mustBeFinite}
                % Object heighti in CCD.                
            end
                 
            % H: Height in real life. b/B = g/G
            H =  obj.g*B/obj.b;
            
        end
        
        function [G] = SizegivenFOV(obj, theta)
            %CCDtoReal: Returns Thethe height in Real life given the height
            %on CCD
            %   Arguments:
            %   theta-> Full angle of FOV in degrees. 
            arguments
                obj
                % Object distance from les (camera)
                theta (1,1) {mustBePositive, mustBeNonzero, mustBeFinite}
                % Object heighti in CCD.
            end
            
            G = tand(theta/2) * obj.g *2;
            
            
        end

    end
end

