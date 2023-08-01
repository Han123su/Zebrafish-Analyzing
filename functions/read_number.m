function output_Angle_Array = read_number(input_Value1,input_Value2)
    
    value1_Str = string(input_Value1);
    value2_Str = string(input_Value2);
    
    value1_Number1 = extractBefore(value1_Str,2);
    value1_Number2 = extractBefore(reverse(value1_Str),2);

    value2_Number1 = extractBefore(value2_Str,2);
    value2_Number2 = extractBefore(reverse(value2_Str),2);

    output_Angle_Array = [double(value1_Number1),double(value1_Number2),double(value2_Number1),double(value2_Number2)]; % index


end