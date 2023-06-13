/// <summary>
/// PageExtension FK Payment Method (ID 60072) extends Record Payment Methods.
/// </summary>
pageextension 60072 "FK Payment Method" extends "Payment Methods"
{
    layout
    {
        addafter(Description)
        {
            field("TPP Payment Option"; Rec."TPP Payment Option")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Payment Option field.';
            }
        }
    }
}
