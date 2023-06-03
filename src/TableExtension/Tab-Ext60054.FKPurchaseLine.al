/// <summary>
/// TableExtension FK Purchase Line (ID 60054) extends Record Purchase Line.
/// </summary>
tableextension 60054 "FK Purchase Line" extends "Purchase Line"
{
    fields
    {

        field(60050; "Ref. GR No. Intranet"; Code[20])
        {
            Caption = 'Ref. GR No. Intranet';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60051; "Temp. Lot No."; Code[50])
        {
            Caption = 'Temp. Lot No.';
            DataClassification = CustomerContent;
        }
        field(60052; "Temp. Expire Date"; date)
        {
            Caption = 'Temp. Expire Date';
            DataClassification = CustomerContent;
        }
    }
}
