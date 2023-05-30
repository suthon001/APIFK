tableextension 60062 "FK Sales Header" extends "Sales Header"
{
    fields
    {
        field(60050; "Interface Complete"; Boolean)
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
