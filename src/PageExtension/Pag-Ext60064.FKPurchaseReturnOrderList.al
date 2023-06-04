/// <summary>
/// PageExtension FK Purchase Return Order List (ID 60064) extends Record Purchase Return Order List.
/// </summary>
pageextension 60064 "FK Purchase Return Order List" extends "Purchase Return Order List"
{
    actions
    {
        modify(Print)
        {
            Visible = false;
        }
        addafter(Print)
        {
            action("Purchase Return Order")
            {
                Caption = 'Purchase Return Order';
                Image = PrintReport;
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Purchase Return Order action.';
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset();
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"TPP Purchase Return Order", true, false, PurchaseHeader);
                end;

            }
        }

    }
}

