tableextension 60059 "FK Item Journal Line" extends "Item Journal Line"
{
    fields
    {
        field(60050; "Temp. Lot No."; Code[50])
        {
            Caption = 'Temp. Lot No.';
            DataClassification = ToBeClassified;
        }
        field(60051; "Temp. Expire Date"; date)
        {
            Caption = 'Temp. Expire Date';
            DataClassification = ToBeClassified;
        }
    }
}
