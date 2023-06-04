/// <summary>
/// PageExtension FK Purchase Order List (ID 60061) extends Record Purchase Order List.
/// </summary>
pageextension 60061 "FK Purchase Order List" extends "Purchase Order List"
{
    actions
    {
        modify(Print)
        {
            Visible = false;
        }
        addafter(Print)
        {
            action("Purchase Order")
            {
                Caption = 'Purchase Order';
                Image = PrintReport;
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Purchase Order action.';
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset();
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"TPP Purchase Order", true, false, PurchaseHeader);
                end;

            }
        }
        modify(Post)
        {
            Visible = false;
        }
        modify(PostAndPrint)
        {
            Visible = false;
        }
        modify(PostBatch)
        {
            Visible = false;
        }
        modify(PostedPurchaseInvoices)
        {
            Visible = false;
        }
        modify(PostedPurchasePrepmtInvoices)
        {
            Visible = false;
        }

    }
}
