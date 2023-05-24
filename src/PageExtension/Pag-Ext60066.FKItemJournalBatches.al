/// <summary>
/// PageExtension FK Item Journal Batches (ID 60066) extends Record Item Journal Batches.
/// </summary>
pageextension 60066 "FK Item Journal Batches" extends "Item Journal Batches"
{
    layout
    {
        addafter("No. Series")
        {
            field("Document No. Series"; Rec."Document No. Series")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field';
            }
        }
    }
}
