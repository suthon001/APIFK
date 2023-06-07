/// <summary>
/// TableExtension FK Customer (ID 60051) extends Record Customer.
/// </summary>
tableextension 60052 "FK Customer" extends Customer
{
    fields
    {

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
