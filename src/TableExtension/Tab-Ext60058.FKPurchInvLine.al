/// <summary>
/// TableExtension FK Purch. Inv. Line (ID 60058) extends Record Purch. Inv. Line.
/// </summary>
tableextension 60058 "FK Purch. Inv. Line" extends "Purch. Inv. Line"
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
