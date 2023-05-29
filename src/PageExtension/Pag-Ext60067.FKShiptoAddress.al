/// <summary>
/// PageExtension FK Ship-to Address (ID 60067) extends Record Ship-to Address.
/// </summary>
pageextension 60067 "FK Ship-to Address" extends "Ship-to Address"
{
    layout
    {
        addlast(General)
        {
            field("Vat Registration No."; Rec."Vat Registration No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }
    }
}
