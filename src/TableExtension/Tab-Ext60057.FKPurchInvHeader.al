/// <summary>
/// TableExtension FK Purch. Inv. Header (ID 60057) extends Record Purch. Inv. Header.
/// </summary>
tableextension 60057 "FK Purch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(60050; "Ref. GR No. Intranet"; Code[20])
        {
            Caption = 'Ref. GR No. Intranet';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
