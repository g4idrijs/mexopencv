%STEREORECTIFY  Computes rectification transforms for each head of a calibrated stereo camera
%
%    S = cv.stereoRectify(cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2, imageSize, R, T)
%    [...] = cv.stereoRectify(..., 'OptionName', optionValue, ...)
%
% ## Input
% * __cameraMatrix1__ First camera matrix 3x3.
% * __cameraMatrix2__ Second camera matrix 3x3.
% * __distCoeffs1__ First camera distortion parameters of 4, 5, 8, or 12
%       elements.
% * __distCoeffs2__ Second camera distortion parameters of 4, 5, 8, or 12
%       elements.
% * __imageSize__ Size of the image used for stereo calibration `[w,h]`.
% * __R__ Rotation matrix between the coordinate systems of the first and the
%       second cameras, 3x3/3x1 (see cv.Rodrigues)
% * __T__ Translation vector between coordinate systems of the cameras, 3x1.
%
% ## Output
% * __S__ scalar struct having the following fields:
%       * __R1__ 3x3 rectification transform (rotation matrix) for the first
%             camera.
%       * __R2__ 3x3 rectification transform (rotation matrix) for the second
%             camera.
%       * __P1__ 3x4 projection matrix in the new (rectified) coordinate
%             systems for the first camera.
%       * __P2__ 3x4 projection matrix in the new (rectified) coordinate
%             systems for the second camera.
%       * __Q__ 4x4 disparity-to-depth mapping matrix (see
%             cv.reprojectImageTo3D).
%       * __roi1__, __roi2__ rectangles inside the rectified images where all
%             the pixels are valid `[x,y,w,h]`. If `Alpha=0`, the ROIs cover
%             the whole images. Otherwise, they are likely to be smaller.
%
% ## Options
% * __ZeroDisparity__ If the flag is set, the function makes the principal
%       points of each camera have the same pixel coordinates in the rectified
%       views. And if the flag is not set, the function may still shift the
%       images in the horizontal or vertical direction (depending on the
%       orientation of epipolar lines) to maximize the useful image area.
%       default true.
% * __Alpha__ Free scaling parameter. If it is -1 or absent, the function
%       performs the default scaling. Otherwise, the parameter should be
%       between 0 and 1. `Alpha=0` means that the rectified images are zoomed
%       and shifted so that only valid pixels are visible (no black areas
%       after rectification). `Alpha=1` means that the rectified image is
%       decimated and shifted so that all the pixels from the original iamges
%       from the cameras are retained in the rectified images (no source image
%       pixels are lost). Obviously, any intermediate value yields an
%       intermediate result between those two extreme cases. default -1
% * __NewImageSize__ New image resolution after rectification. The same size
%       should be passed to cv.initUndistortRectifyMap. When [0,0] is passed
%       (default), it is set to the original `imageSize`. Setting it to larger
%       value can help you preserve details in the original image, especially
%       when there is a big radial distortion.
%
% The function computes the rotation matrices for each camera that (virtually)
% make both camera image planes the same plane. Consequently, this makes all
% the epipolar lines parallel and thus simplifies the dense stereo
% correspondence problem. The function takes the matrices computed by
% cv.stereoCalibrate as input. As output, it provides two rotation matrices
% and also two projection matrices in the new coordinates. The function
% distinguishes the following two cases:
%
% 1. **Horizontal stereo**: the first and the second camera views are shifted
% relative to each other mainly along the x axis (with possible small vertical
% shift). In the rectified images, the corresponding epipolar lines in the
% left and right cameras are horizontal and have the same y-coordinate. `P1`
% and `P2` look like:
%
%        P1 = [f 0 cx1 0;
%              0 f cy  0;
%              0 0 1   0]
%
%        P2 = [f 0 cx2 Tx*f;
%              0 f cy     0;
%              0 0 1      0]
%
%    where `Tx` is a horizontal shift between the cameras and `cx1=cx2` if
% 'ZeroDisparity' is set.
%
% 2. **Vertical stereo**: the first and the second camera views are shifted
% relative to each other mainly in vertical direction (and probably a bit in
% the horizontal direction too). The epipolar lines in the rectified images
% are vertical and have the same x-coordinate. `P1` and `P2` look like:
%
%        P1 = [f 0 cx  0;
%              0 f cy1 0;
%              0 0 1   0]
%
%        P2 = [f 0 cx     0;
%              0 f cy2 Ty*f;
%              0 0 1      0]
%
%    where `Ty` is a vertical shift between the cameras and `cy1=cy2` if
% 'ZeroDisparity' is set.
%
% As you can see, the first three columns of `P1` and `P2` will effectively be
% the new "rectified" camera matrices. The matrices, together with `R1` and
% `R2`, can then be passed to cv.initUndistortRectifyMap to initialize the
% rectification map for each camera.
%
% See the output of the calibration_demo.m sample. Some red horizontal lines
% pass through the corresponding image regions. This means that the images are
% well rectified, which is what most stereo correspondence algorithms rely on.
% The green rectangles are `roi1` and `roi2`. You see that their interiors are
% all valid pixels.
%
% See also: cv.stereoCalibrate, cv.stereoRectifyUncalibrated
%
