%% Matrix Methods of Linear Algebra
% <html>
% <span style="font-family:Arial">
% <span style="font-size:12pt">
% <h2> Information </h2>
% This curriculum module contains interactive
% <a href="https://www.mathworks.com/products/matlab/live-editor.html">MATLAB&reg; live scripts</a>
% that teach fundamental concepts and basic terminology related to matrix methods commonly taught in introductory 
% linear algebra courses. In the first part of each live script, students learn standard definitions, visualize 
% concepts, and perform exercises on paper. Afterward, students practice complementary MATLAB&reg; methods. These 
% methods reinforce the discussed concepts and help students to develop an early familiarity with computational 
% software. Each lesson concludes with an illustrative application.
% <br>
% <br>
% <a href=#module>Matrix Methods of Linear Algebra</a> covers
% <a href=#script1>matrix operations</a>, <a href=#script2>linear systems</a>, and <a href=#script3>eigenanalysis</a>. 
% Applications include <a href=#script4>linear regression</a>, <a href=#script4>linear circuit analysis</a>, <a href=#script5>vibrating masses</a>, and <a href=#script5>Markov chains</a>.
% <br>
% <br>
% You can use these live scripts as demonstrations in a lecture, class activities,
% or interactive assignments outside of class. The module is divided into five live scripts organized by topic: matrix operations, linear systems, 
% applications of linear systems, eigenanalysis, and applications of eigenanalysis.
% <br>
% <br>
% The instructions inside the live scripts will guide you through the exercises and activities.
% Get started with each live script by running it one section at a time. To stop running the script
% or a section midway (for example, when an animation is in progress), use the <img src="../Images/StopIcon.png" height="16" style="vertical-align:top"> Stop button in the
% RUN section of the Live Editor tab in the MATLAB Toolstrip.
% <br>
% <br>
% If you find an issue or have a suggestion, email the MathWorks online teaching team at
% <a href="mailto:onlineteaching@mathworks.com">onlineteaching@mathworks.com</a>.
% <br>
% <br>
% <h2> Related Courseware Modules </h2>    
% <ol>
%     <li> Matrix Methods of Linear Algebra available on <a href="https://github.com/MathWorks-Teaching-Resources/Matrix-Methods-of-Linear-Algebra">
%         GitHub</a> or <a href="https://www.mathworks.com/matlabcentral/fileexchange/94730-matrix-methods-of-linear-algebra">
%         <img src="https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg"> </a>
%     </li>
% </ol>
% <h2> Getting Started </h2>
% <ol>
%     <li>
%         Make sure that you have all the required products (listed below)
%         installed. If you are missing a product, add it using the
%         <a href="https://www.mathworks.com/products/matlab/add-on-explorer.html">
%             Add-On Explorer.</a> To install an add-on, go to the <b>Home</b>
%         tab and select <img src="../Images/add-ons.png" style="margin:0px;" height=12> <b> Add-Ons > Get Add-Ons</b>.
%     </li>
%         <li>
%             Get started with each topic by clicking the link in the first column of the table below to access the
%             full script example. The instructions inside each live script will walk
%             you through the live scripts and related functions.
%         </li>
% </ol>
% <h2> Products </h2>
%     MATLAB&reg; is used throughout. Tools from the Symbolic Math Toolbox&trade; are used in
%     <code>matrixOperations.mlx</code>, <code>linearSystems.mlx</code>,
%     <code>eigenanalysis.mlx</code>, and <code>eigenanalysisApplications.mlx</code>. 
%     Tools from the Image Processing Toolbox&trade; are used in <code>matrixOperations.mlx</code>.
%     Tools from the Statistics and Machine Learning Toolbox&trade; are used in
%     <code>linearSystemsApplications.mlx</code>.
% <br>
% <br>
% <h2> <a name="module">Scripts</a> </h2>
% <table border=1 style="margin-left:20px; cellpadding:15px;">
%     <caption><h3>Organization of the Matrix Methods of Linear Algebra Module</h3></caption>
%     <tr>
%         <th scope="col">Topic
%         </th>
%         <th scope="col">In this script, students will...
%         </th>
%     </tr>
%     <tr>
%         <th scope="row">
%             <a name="script1"; href="matlab:edit matrixOperations.mlx;"><b>Matrix Operations</b> 
%              <br>
%             <img src = "../Images/matrixOperations.png" width=150 style="margin-top:5px; margin-bottom:0px">
%             </a>
%         </th>              
%         <td>
%             <ul style="margin-top:5px; margin-bottom:10px">
%                 <li> Define matrices and their basic arithmetic operations </li>
%                 <li> Calculate the result of matrix operations on paper and in MATLAB </li>
%                 <li> Explain the size requirements of matrix operations </li>
%                 <li> Compare symbolic and numeric matrix operations in MATLAB </li>
%                 <li> Apply matrix methods to modify grayscale images </li>
%             </ul>
%         </td>
%     </tr>
%     <tr>
%         <th scope="row">
%             <a name="script2"; href="matlab:edit linearSystems.mlx;"><b>Linear Systems</b> 
%              <br>
%             <img src = "../Images/linearSystems.png" width=150 style="margin-top:5px; margin-bottom:0px">
%             </a>
%         </th>              
%         <td>
%             <ul style="margin-top:5px; margin-bottom:10px">
%                 <li> Write a linear system in matrix form </li>
%                 <li> Relate solutions of linear systems in 3-dimensions to their visualizations </li>
%                 <li> Solve systems of linear equations using row-reduction </li>
%                 <li> Solve systems of linear equations using matrix inverses </li>
%                 <li> Explain the solvability of a linear system in terms of the matrix determinant </li>
%                 <li> Use MATLAB to solve linear systems </li>
%             </ul>
%         </td>
%     </tr>
%     <tr>
%         <th scope="row">
%             <a name="script3"; href="matlab:edit linearSystemsApplications.mlx;"><b>Linear Systems Applications</b> 
%              <br>
%             <img src = "../Images/linearSystemsApplications.png" width=150 style="margin-top:5px; margin-bottom:0px">
%             </a>
%         </th>              
%         <td>
%             <ul style="margin-top:5px; margin-bottom:10px">
%                 <li> Apply matrix methods to linear regression and linear circuit analysis </li>
%             </ul>
%         </td>
%     </tr>
%     <tr>
%         <th scope="row">
%             <a name="script4"; href="matlab:edit eigenanalysis.mlx;"><b>Eigenanalysis</b> 
%              <br>
%             <img src = "../Images/eigenanalysis.png" width=150 style="margin-top:5px; margin-bottom:0px">
%             </a>
%         </th>              
%         <td>
%             <ul style="margin-top:5px; margin-bottom:10px">
%                 <li> Visualize eigenvectors in 2-dimensions </li>
%                 <li> Solve for the eigenvalues and eigenvectors of a 2x2 matrix on paper and larger matrices using MATLAB </li>
%                 <li> Diagonalize 2x2 matrices on paper and larger matrices in MATLAB </li>
%                 <li> Explain linear system solvability in terms of eigenvalues </li>
%                 <li> Discuss defective matrices </li>
%             </ul>
%         </td>
%     </tr>
%     <tr>
%         <th scope="row">
%             <a name="script5"; href="matlab:edit eigenanalysisApplications.mlx;"><b>Eigenanalysis Applications</b> 
%              <br>
%             <img src = "../Images/eigenanalysisApplications.png" width=150 style="margin-top:5px; margin-bottom:0px">
%             </a>
%         </th>              
%         <td>
%             <ul style="margin-top:5px; margin-bottom:10px">
%                 <li> Use eigenanalysis to understand vibrations and the long term behavior of a Markov chain </li>
%             </ul>
%         </td>
%     </tr>
% </table>
% <br>
% </span>
% </span>
% </html>
% 
% Copyright 2021-2022 The MathWorks(TM), Inc.

