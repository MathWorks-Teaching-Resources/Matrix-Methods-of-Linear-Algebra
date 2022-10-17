classdef smokeTests < matlab.unittest.TestCase
    properties (TestParameter)
        filename = {"matrixOperationsSoln.mlx", "linearSystems.mlx", ...
            "linearSystemsSoln.mlx", "linearSystemsApplications.mlx", ...
            "linearSystemsApplicationsSoln.mlx", "eigenanalysis.mlx", ...
            "eigenanalysisSoln.mlx", "eigenanalysisApplications.mlx", ...
            "eigenanalysisApplicationsSoln.mlx"};
    end

    methods(Test)
        function testNoError(testCase, filename)
            toPrint = append("Running ", filename);
            testCase.log(toPrint);

            run(filename);
        end

        function testMatrixOperations(testCase)
            testCase.log("Running matrixOperations.mlx");

            verifyError(testCase, @matrixOperations, 'MATLAB:sizeDimensionsMustMatch');
        end
    end
end