/// <summary>
/// TableExtension FK Payment Method (ID 60064) extends Record Payment Method.
/// </summary>
tableextension 60064 "FK Payment Method" extends "Payment Method"
{
    fields
    {
        field(60050; "TPP Payment Option"; Option)
        {
            Caption = 'Payment Option';
            OptionCaption = 'Cash,Cheque,Transfer,Online';
            OptionMembers = Cash,Cheque,Transfer,Online;
            DataClassification = CustomerContent;
        }
    }
}
