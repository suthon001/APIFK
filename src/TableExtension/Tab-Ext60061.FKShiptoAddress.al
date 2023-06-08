/// <summary>
/// TableExtension FK Ship-to Address (ID 60061) extends Record Ship-to Address.
/// </summary>
tableextension 60061 "FK Ship-to Address" extends "Ship-to Address"
{
    fields
    {
        field(60050; "Vat Registration No."; Text[20])
        {
            Caption = 'Vat Registration No.';
            DataClassification = CustomerContent;
        }
        field(69999; "Is Successfully"; Boolean)
        {
            Caption = 'Is Successfully';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70000; "Already Send"; Boolean)
        {
            Caption = 'Already Send';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70001; "Is API"; Boolean)
        {
            Caption = 'Is API';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    trigger OnInsert()
    begin
        if not (CurrentClientType in [CurrentClientType::Api, CurrentClientType::OData, CurrentClientType::ODataV4]) then
            rec."Is Successfully" := true;
    end;
}
