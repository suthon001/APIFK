/// <summary>
/// Page FK Purch. Billing Card (ID 60075).
/// </summary>
page 60075 "FK Purch. Billing Card"
{
    PageType = Document;
    SourceTable = "TPP Billing - Receipt Header";
    SourceTableView = where("TPP Document Type" = const("P. Billing"));
    Caption = 'Purchase Billing Card';
    RefreshOnActivate = true;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group("TPP General")
            {
                Caption = 'General';
                Editable = rec."TPP Status" = rec."TPP Status"::Open; //TPP.SSI 2022/03/28
                field("TPP No."; Rec."TPP No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
                    trigger OnDrillDown()
                    begin
                        if Rec.AssistEdit(xrec) then
                            CurrPage.Update();
                    end;
                }
                field("TPP Vendor No."; Rec."TPP Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field("TPP Vendor Name"; Rec."TPP Vendor Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("TPP Vendor Name 2"; Rec."TPP Vendor Name 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor Name 2 field.';
                }
                field("TPP Vendor Address"; Rec."TPP Vendor Address")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor Address field.';
                }
                field("TPP Vendor Address 2"; Rec."TPP Vendor Address 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor Address 2 field.';
                }
                field("TPP City"; Rec."TPP City")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the City field.';
                }
                field("TPP Post Code"; Rec."TPP Post Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
                field("TPP Document Date"; Rec."TPP Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("TPP Payment Term Code"; Rec."TPP Payment Term Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Billing Term Code field.';
                }
                field("TPP Payment Method"; Rec."TPP Payment Method")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payment Method field.';
                }
                field("TPP Due Date"; Rec."TPP Due Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field("TPP Currency Code"; Rec."TPP Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("TPP Remark"; Rec."TPP Remark")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Remark field.';
                }
                // field("TPP Total Amount"; Rec."TPP Total Amount") { ApplicationArea = all; }
                field("TPP Total Amount (LCY)"; Rec."TPP Total Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Total Amount (LCY) field.';
                    ApplicationArea = All;
                }
                field("TPP Status"; Rec."TPP Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            part("TPP MyPurchBillingSubform"; "FK Purch. Billing Subform")
            {
                Caption = 'Lines';
                SubPageLink = "TPP Document Type" = field("TPP Document Type"), "TPP Document No." = field("TPP No.");
                UpdatePropagation = Both;
                ApplicationArea = all;
                Editable = rec."TPP Status" = rec."TPP Status"::Open; //TPP.SSI 2022/03/28
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("TPP Release")
            {
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                Caption = 'Release';
                ToolTip = 'Executes the Release action.';
                trigger OnAction()
                begin
                    IF Rec."TPP Status" <> Rec."TPP Status"::Released THEN
                        Rec."TPP Status" := Rec."TPP Status"::Released;

                    //TPP.SSI 2022/03/28++
                    CurrPage.SaveRecord();
                    CurrPage.Update(false);
                    //TPP.SSI 2022/03/28--

                end;
            }
            action("TPP Open")
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                Caption = 'Open';
                ToolTip = 'Executes the Open action.';
                trigger OnAction()
                begin
                    IF Rec."TPP Status" <> Rec."TPP Status"::Open THEN
                        Rec."TPP Status" := Rec."TPP Status"::Open;
                    //TPP.SSI 2022/03/28++
                    CurrPage.SaveRecord();
                    CurrPage.Update(false);
                    //TPP.SSI 2022/03/28--
                end;
            }
        }
        area(Reporting)
        {
            group("TPP Report")
            {
                Caption = 'Report';
                action("TPP Purchase Billing")
                {
                    Image = PrintReport;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    Caption = 'Purchase Billing';
                    ToolTip = 'Executes the Purchase Billing action.';
                    trigger OnAction()
                    var
                        PurchaseBilling: Record "TPP Billing - Receipt Header";
                    begin
                        //TPP.SSI 2022/03/28++
                        CurrPage.SaveRecord();
                        CurrPage.Update(false);
                        //TPP.SSI 2022/03/28--

                        PurchaseBilling.reset();
                        PurchaseBilling.SetFilter("TPP Document Type", '%1', Rec."TPP Document type");
                        PurchaseBilling.SetFilter("TPP No.", '%1', Rec."TPP No.");
                        Report.Run(Report::"FK Purchase Billing", true, true, PurchaseBilling);
                    end;
                }
            }
        }
    }
}