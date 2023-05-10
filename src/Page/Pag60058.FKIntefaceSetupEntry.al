page 60058 "FK Inteface Setup Entry"
{
    PromotedActionCategories = 'Log,Test Import';
    Caption = 'Inteface Setup Entry';
    SourceTable = "FK Interface Setup";
    ApplicationArea = Basic, Suite;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            group(Purchase)
            {
                Caption = 'Purchase Interface';
                group(ItemJournalPositive)
                {
                    Caption = 'Item Journal Positive';

                    field("Item Journal Temp. Name (pos.)"; Rec."Item Journal Temp. Name (pos.)")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Temp. Name (pos.) field.';
                        ApplicationArea = all;
                    }
                    field("Item Journal Batch Name (Pos.)"; Rec."Item Journal Batch Name (Pos.)")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Batch Name (Pos.) field.';
                        ApplicationArea = all;
                    }
                    field("Item Journal Positive Path"; Rec."Item Journal Positive Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Positive Path field.';
                        ApplicationArea = all;
                    }
                    field("Item Journal Pos. Success Path"; Rec."Item Journal Pos. Success Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Pos. Success Path field.';
                        ApplicationArea = all;
                    }
                    field("Item Journal Pos. Error Path"; Rec."Item Journal Pos. Error Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Pos. Error Path field.';
                        ApplicationArea = all;
                    }
                }
                group(ItemJournalNegative)
                {
                    Caption = 'Item Journal Negative';
                    field("Item Journal Temp. Name (Neg.)"; Rec."Item Journal Temp. Name (Neg.)")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Temp. Name (Neg.) field.';
                        ApplicationArea = all;
                    }
                    field("Item Journal Batch Name (Neg.)"; Rec."Item Journal Batch Name (Neg.)")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Batch Name (Neg.) field.';
                        ApplicationArea = all;
                    }
                    field("Item Journal Nagative Path"; Rec."Item Journal Nagative Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Nagative Path field.';
                        ApplicationArea = all;
                    }
                    field("Item Journal Neg. Success Path"; Rec."Item Journal Neg. Success Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Neg. Success Path field.';
                        ApplicationArea = all;
                    }
                    field("Item Journal Neg. Error Path"; Rec."Item Journal Neg. Error Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Neg. Error Path field.';
                        ApplicationArea = all;
                    }
                }
                group(ItemReclass)
                {
                    Caption = 'Item Reclass';
                    field("Item Journal Temp. Name (Rec.)"; Rec."Item Journal Temp. Name (Rec.)")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Temp. Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Item Journal Batch Name (Rec.)"; Rec."Item Journal Batch Name (Rec.)")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Batch Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Item Journal Reclass Path"; Rec."Item Journal Reclass Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Reclass Path field.';
                        ApplicationArea = all;
                    }
                    field("Item Journal Rec. Success Path"; Rec."Item Journal Rec. Success Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Reclass Success Path field.';
                        ApplicationArea = all;
                    }
                    field("Item Journal Rec. Error Path"; Rec."Item Journal Rec. Error Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Reclass Error Path field.';
                        ApplicationArea = all;
                    }
                }
                group(PurchaseOrder)
                {
                    Caption = 'Purchase Order';
                    field("Purchase Order Path"; Rec."Purchase Order Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Temp. Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Purchase Order Succ. Path"; Rec."Purchase Order Succ. Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Batch Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Purchase Order Error Path"; Rec."Purchase Order Error Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Reclass Path field.';
                        ApplicationArea = all;
                    }

                }
                group(PurchaseGRN)
                {
                    Caption = 'Purchase GRN';
                    field("Purchase GRN Path"; Rec."Purchase GRN Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Temp. Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Purch. GRN Succ. Path"; Rec."Purch. GRN Succ. Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Batch Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Purch. GRN Error Path"; Rec."Purch. GRN Error Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Reclass Path field.';
                        ApplicationArea = all;
                    }

                }
                group(PurchaseReturn)
                {
                    Caption = 'Return Order';
                    field("Purchase Return Order Path"; Rec."Purchase Return Order Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Temp. Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Purch. Return Order Succ. Path"; Rec."Purch. Return Order Succ. Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Batch Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Purch. Return Order Error Path"; Rec."Purch. Return Order Error Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Reclass Path field.';
                        ApplicationArea = all;
                    }

                }
                group(ReturntoShip)
                {
                    Caption = 'Return to Ship';
                    field("Return to ship Path"; Rec."Return to ship Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Temp. Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Return to ship Succ. Path"; Rec."Return to ship Succ. Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Batch Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Return to ship Err Path"; Rec."Return to ship Err Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Reclass Path field.';
                        ApplicationArea = all;
                    }

                }
            }
            Group(Sales)
            {

                Caption = 'Sales Interface';
                group(CashReceipt)
                {
                    Caption = 'Cash Receipt';
                    field("Cash Receipt Temp. Name"; Rec."Cash Receipt Temp. Name")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Temp. Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Cash Receipt Batch Name"; Rec."Cash Receipt Batch Name")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Batch Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Cash Receipt Path"; Rec."Cash Receipt Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Reclass Path field.';
                        ApplicationArea = all;
                    }
                    field("Cash Receipt Success Path"; Rec."Cash Receipt Success Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Reclass Success Path field.';
                        ApplicationArea = all;
                    }
                    field("Cash Receipt Error Path"; Rec."Cash Receipt Error Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Reclass Error Path field.';
                        ApplicationArea = all;
                    }
                }
                group(SalesInvoice)
                {
                    Caption = 'Sales Invoice';
                    field("Sales Invoice Path"; Rec."Sales Invoice Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Temp. Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Sales Invoice Succ. Path"; Rec."Sales Invoice Succ. Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Batch Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Sales Invoice Err Path"; Rec."Sales Invoice Err Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Reclass Path field.';
                        ApplicationArea = all;
                    }

                }
                group(SalesCreditMemo)
                {
                    Caption = 'Sales Credit Memo';
                    field("Sales Credit Path"; Rec."Sales Credit Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Temp. Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Sales Credit Succ. Path"; Rec."Sales Credit Succ. Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Batch Name (Reclass) field.';
                        ApplicationArea = all;
                    }
                    field("Sales Credit Err Path"; Rec."Sales Credit Err Path")
                    {
                        ToolTip = 'Specifies the value of the Item Journal Reclass Path field.';
                        ApplicationArea = all;
                    }

                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(LogHistory)
            {
                Caption = 'Log';
                Image = Log;
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Log Import';
                trigger OnAction()
                var
                    FKLogEntry: Record "FK API Log";
                    FKAPILogEntries: Page "FK API Log Entry";
                begin
                    CLEAR(FKAPILogEntries);
                    FKLogEntry.reset();
                    FKLogEntry.SetFilter("No.", '%1|%2|%3|%4', 36, 38, 81, 83);
                    FKAPILogEntries.SetTableView(FKLogEntry);
                    FKAPILogEntries.RunModal();
                    CLEAR(FKAPILogEntries);
                end;
            }

            action(testImportItemJournalPos)
            {
                Caption = 'Test Import Item Journal (Positive)';
                Image = Import;
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Import Data';
                trigger OnAction()
                var
                    FKFunc: Codeunit "FK Func";
                begin
                    FKFunc.ImportItemJournalPositive(true);
                end;

            }
            action(testImportItemJournalNeg)
            {
                Caption = 'Test Import Item Journal (Negative)';
                Image = Import;
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Import Data';
                trigger OnAction()
                var
                    FKFunc: Codeunit "FK Func";
                begin
                    FKFunc.ImportItemJournalNegative(true);
                end;

            }
            action(testImportItemJournalReclass)
            {
                Caption = 'Test Import Item Journal (Reclass)';
                Image = Import;
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Import Data';
                trigger OnAction()
                var
                    FKFunc: Codeunit "FK Func";
                begin
                    FKFunc.ImportItemJournalReclass(true);
                end;

            }
            action(testImportPO)
            {
                Caption = 'Test Import PO';
                Image = Import;
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Import Data';
                trigger OnAction()
                var
                    FKFunc: Codeunit "FK Func";
                begin
                    FKFunc.ImportPO(true);
                end;

            }
            action(testImportReturn)
            {
                Caption = 'Test Import Return Order';
                Image = Import;
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Import Data';
                trigger OnAction()
                var
                    FKFunc: Codeunit "FK Func";
                begin
                    FKFunc.ImportReturnOrder(true);
                end;

            }
            action(testImportGRN)
            {
                Caption = 'Test Update GRN';
                Image = Import;
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Import Data';
                trigger OnAction()
                var
                    FKFunc: Codeunit "FK Func";
                begin
                    FKFunc.ImportUpdateGRN(true);
                end;

            }
            action(testUpdateReturn)
            {
                Caption = 'Update Return to Ship';
                Image = Import;
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Import Data';
                trigger OnAction()
                var
                    FKFunc: Codeunit "FK Func";
                begin
                    FKFunc.ImportUpdateReturnShip(true);
                end;

            }

            action(testUpdateSalesInvoice)
            {
                Caption = 'Import Sales Invoice';
                Image = Import;
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Import Data';
                trigger OnAction()
                var
                    FKFunc: Codeunit "FK Func";
                begin
                    FKFunc.ImportToSalesInvoice(true);
                end;

            }
            action(testUpdateSalesCredit)
            {
                Caption = 'Import Sales Credit';
                Image = Import;
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Import Data';
                trigger OnAction()
                var
                    FKFunc: Codeunit "FK Func";
                begin
                    FKFunc.ImportToSalesCreditMemo(true);
                end;

            }
            action(testUpdateCashReceipt)
            {
                Caption = 'Import Cash Receipt';
                Image = Import;
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Import Data';
                trigger OnAction()
                var
                    FKFunc: Codeunit "FK Func";
                begin
                    FKFunc.ImportToCashReceipt(true);
                end;

            }

        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;


}
