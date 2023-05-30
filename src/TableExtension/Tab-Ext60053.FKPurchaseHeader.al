/// <summary>
/// TableExtension FK Purchase Header (ID 60053) extends Record Purchase Header.
/// </summary>
tableextension 60053 "FK Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(60050; "Ref. GR No. Intranet"; Code[20])
        {
            Caption = 'Ref. GR No. Intranet';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60051; "Vendor No. Intranet"; Code[20])
        {
            Caption = 'Vendor No. Intranet';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60052; "Interface Complete"; Boolean)
        {
            Caption = 'nterface Complete';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    trigger OnInsert()
    begin
        if not rec.IsTemporary then
            rec."Interface Complete" := true;
    end;
}
