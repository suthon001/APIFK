/// <summary>
/// TableExtension FK Item (ID 60051) extends Record Item.
/// </summary>
tableextension 60051 "FK Item" extends Item
{
    fields
    {
        field(70000; "Already Send"; Boolean)
        {
            Caption = 'Already Send';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(69999; "Is Successfully"; Boolean)
        {
            Caption = 'Is Successfully';
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
