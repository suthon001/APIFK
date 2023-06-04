/// <summary>
/// Page FK Good ReceiptNote Subpage (ID 60057).
/// </summary>
page 60057 "FK Good ReceiptNote Subpage"
{
    SourceTable = "Purchase Line";
    SourceTableView = sorting("Document Type", "Document No.", "Line No.");
    PageType = ListPart;
    Caption = 'Lines';
    layout
    {
        area(Content)
        {
            repeater("TPP General")
            {
                Caption = 'Lines';
                field("TPP Type"; Rec.Type)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                    trigger OnValidate()
                    begin
                        IF xRec."No." <> '' THEN
                            "TPP RedistributeTotalsOnAfterValidate"();
                    end;

                }
                field("TPP No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                    trigger OnValidate()
                    begin
                        IF xRec."No." <> '' THEN
                            "TPP RedistributeTotalsOnAfterValidate"();
                    end;

                }
                field("TPP Description"; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Description 2"; Rec."Description 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Quantity"; Rec.Quantity)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                    trigger OnValidate()
                    begin
                        "TPP RedistributeTotalsOnAfterValidate"();
                    end;
                }
                field("TPP Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Qty. to Receive"; Rec."Qty. to Receive")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("TPP Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Ref. GR No. Intranet"; Rec."Ref. GR No. Intranet")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
            }
            group("TPP Total")
            {
                Caption = '';
                group("TPP Control37")
                {
                    Caption = '';
                    field("TPP Invoice Discount Amount"; TotalPurchaseLine."Inv. Discount Amount")
                    {
                        Caption = 'Invoice Discount Amount';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the total calculated invoice discount amount for the line.';
                    }
                    field("TPP Invoice Disc. Pct."; PurchCalcDiscByType.GetVendInvoiceDiscountPct(Rec))
                    {
                        Caption = 'Invoice Disc. Pct.';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Invoice Disc. Pct. field.';
                    }
                }
                group("TPP Control19")
                {
                    Caption = '';
                    field("TPP Total Amount Excl. VAT"; TotalPurchaseLine.Amount)
                    {
                        Caption = 'Total Amount Excl. VAT';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the sum of amounts in the Line Amount field on the purchase order lines.';
                    }
                    field("TPP Total VAT Amount"; VATAmount)
                    {
                        Caption = 'Total VAT Amount';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Total VAT Amount field.';
                    }
                    field("TPP Total Amount Incl. VAT"; TotalPurchaseLine."Amount Including VAT")
                    {
                        Caption = 'Total Amount Incl. VAT';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Total Amount Incl. VAT field.';
                    }
                }
            }
            group("TPP Update Totals")
            {
                Caption = '';
                ShowCaption = false;
                Visible = RefreshMessageEnabled;
                field("TPP ManualUpdateLbl"; ManualUpdateLbl)
                {
                    Caption = 'UpdateTotalsMessage';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the UpdateTotalsMessage field.';
                    trigger OnValidate()
                    begin
                        MESSAGE(ManualUpdateHelpMsg);
                    end;
                }
                field("TPP ManualUpdateActionLbl"; ManualUpdateActionLbl)
                {
                    Caption = 'UpdateTotals';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the UpdateTotals field.';
                    trigger OnDrillDown()
                    begin
                        DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalPurchaseLine);
                        DocumentTotals.PurchaseUpdateTotalsControlsForceable(Rec, TotalPurchaseHeader, TotalPurchaseLine, RefreshMessageEnabled,
                          TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, VATAmount, TRUE);

                    end;
                }
            }


        }

    }
    actions
    {
        Area(Processing)
        {
            group("TPP &Line")
            {
                Caption = 'Line';
                group("TPP Item Availability by")
                {
                    Caption = 'tem Availability by';
                    action("TPP Event")
                    {
                        Caption = 'Event';
                        Image = Event;
                        ApplicationArea = all;
                        ToolTip = 'Executes the Event action.';
                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByEvent())
                        end;
                    }
                    action("TPP Period")
                    {
                        Caption = 'Period';
                        Image = Period;
                        ApplicationArea = all;
                        ToolTip = 'Executes the Period action.';
                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByPeriod());
                        end;
                    }
                    action("TPP Variant")
                    {
                        Caption = 'Variant';
                        Image = ItemVariant;
                        ApplicationArea = all;
                        ToolTip = 'Executes the Variant action.';
                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByVariant());
                        end;
                    }
                    action("TPP Location")
                    {
                        Caption = 'Location';
                        Image = Warehouse;
                        ApplicationArea = all;
                        ToolTip = 'Executes the Location action.';
                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByLocation());
                        end;
                    }
                    action("TPP BOM Level")
                    {
                        Caption = 'BOM Level';
                        Image = BOMLevel;
                        ApplicationArea = all;
                        ToolTip = 'Executes the BOM Level action.';
                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByBOM());
                        end;
                    }
                }
                action("TPP Reservation Entries")
                {
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Reservation Entries action.';
                    trigger OnAction()
                    begin
                        Rec.ShowReservationEntries(TRUE);
                    end;
                }
                action("TPP Item Tracking Lines")
                {
                    Caption = 'Item Tracking Lines';
                    Image = ItemTrackingLines;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Item Tracking Lines action.';
                    trigger OnAction()
                    begin
                        Rec.OpenItemTrackingLines();

                    end;
                }
                action("TPP Dimensions")
                {
                    Caption = 'Dimensions';
                    ApplicationArea = all;
                    Image = Dimensions;
                    ToolTip = 'Executes the Dimensions action.';
                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                    end;
                }
                action("TPP Co&mments")
                {
                    Caption = 'Comment';
                    Image = Comment;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Comment action.';
                    trigger OnAction()
                    begin
                        Rec.ShowLineComments();
                    end;
                }
                action("TPP ItemChargeAssignment")
                {
                    Caption = 'Item Charge Assignment';
                    ApplicationArea = all;
                    Image = ItemCosts;
                    ToolTip = 'Executes the Item Charge Assignment action.';
                    trigger OnAction()
                    begin
                        Rec.ShowItemChargeAssgnt();

                    end;
                }

                // action("TPP DeferralSchedule")
                // {
                //     Caption = 'Deferral Schedule';
                //     Enabled = Rec."Deferral Code" <> '';
                //     ApplicationArea = all;
                //     Image = PaymentPeriod;
                //     trigger OnAction()
                //     begin
                //         Rec.ShowDeferralSchedule;
                //     end;
                // }
                action("TPP DocAttach")
                {
                    Caption = 'Doc. Attch';
                    ApplicationArea = all;
                    Image = Attach;
                    ToolTip = 'Executes the Doc. Attch action.';
                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GETTABLE(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RUNMODAL();
                    end;
                }
            }
            group("TPP F&unctions")
            {
                Caption = 'Function';
                action("TPP E&xplode BOM")
                {
                    Caption = 'Explode BOM';
                    Image = ExplodeBOM;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Explode BOM action.';
                    trigger OnAction()
                    begin
                        ExplodeBOM();
                    end;
                }
                action("TPP Insert Ext. Texts")
                {
                    Caption = 'Insert Ext. Texts';
                    Image = Text;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Insert Ext. Texts action.';
                    trigger OnAction()
                    begin
                        InsertExtendedText(TRUE);
                    end;
                }
                action("TPP Reserve")
                {
                    Caption = 'Reserve';
                    ApplicationArea = all;
                    Image = Reserve;
                    Ellipsis = true;
                    ToolTip = 'Executes the Reserve action.';
                    trigger OnAction()
                    begin
                        Rec.FIND();
                        Rec.ShowReservation();
                    end;
                }
                action("TPP OrderTracking")
                {
                    Caption = 'Order Tracking';
                    Image = OrderTracking;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Order Tracking action.';
                    trigger OnAction()
                    begin
                        ShowTracking();
                    end;
                }
            }

        }
    }
    trigger OnInit()
    begin
        Currency.InitRoundingPrecision();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CLEAR(DocumentTotals);
        IF PurchaseHeader.GET(Rec."Document Type", rec."Document No.") THEN;

        DocumentTotals.PurchaseUpdateTotalsControls(Rec, TotalPurchaseHeader, TotalPurchaseLine, RefreshMessageEnabled,
          TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, VATAmount);
        "TPP UpdateCurrency"();
        //DekDong 20220617++

        DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalPurchaseLine);
        DocumentTotals.PurchaseUpdateTotalsControlsForceable(Rec, TotalPurchaseHeader, TotalPurchaseLine, RefreshMessageEnabled,
          TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, VATAmount, TRUE);
        //DekDong 20220617--
    end;

    trigger OnAfterGetRecord()
    begin
        //TPP.SSI 2022/08/08++
        CLEAR(DocumentTotals);
        //IF PurchaseHeader.GET(Rec."Document Type", rec."Document No.") THEN;
        DocumentTotals.PurchaseUpdateTotalsControls(Rec, TotalPurchaseHeader, TotalPurchaseLine, RefreshMessageEnabled,
          TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, VATAmount);
        "TPP UpdateCurrency"();
        //TPP.SSI 2022/08/08--
    end;

    procedure "TPP UpdateCurrency"()
    begin
        IF Currency.Code <> TotalPurchaseHeader."Currency Code" THEN
            IF NOT Currency.GET(TotalPurchaseHeader."Currency Code") THEN BEGIN
                CLEAR(Currency);
                Currency.InitRoundingPrecision();
            END

    end;

    procedure "TPP RedistributeTotalsOnAfterValidate"()
    begin
        CurrPage.SAVERECORD();

        PurchaseHeader.GET(Rec."Document Type", rec."Document No.");
        IF DocumentTotals.PurchaseCheckNumberOfLinesLimit(PurchaseHeader) THEN
            DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalPurchaseLine);
        CurrPage.UPDATE();
    end;

    local procedure ExplodeBOM()
    begin
        IF Rec."Prepmt. Amt. Inv." <> 0 THEN
            ERROR(Text001);
        CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM", Rec);

    end;

    /// <summary>
    /// ShowTracking.
    /// </summary>
    procedure ShowTracking()
    var
        TrackingForm: Page "Order Tracking";
    begin
        TrackingForm.SetPurchLine(Rec);
        TrackingForm.RUNMODAL();
    end;

    local procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        OnBeforeInsertExtendedText(Rec);
        IF TransferExtendedText.PurchCheckIfAnyExtText(Rec, Unconditionally) THEN BEGIN
            CurrPage.SAVERECORD();
            TransferExtendedText.InsertPurchExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate() THEN
            UpdateForm(TRUE);
    end;

    /// <summary>
    /// ForceTotalsCalculation.
    /// </summary>
    procedure ForceTotalsCalculation()
    begin
        DocumentTotals.PurchaseDocTotalsNotUpToDate();
    end;

    procedure CheckSendLineInvoiceDiscountResetNotification()
    begin


        if rec."Line Amount" <> xRec."Line Amount" then
            rec.SendLineInvoiceDiscountResetNotification();
    end;
    /// <summary>
    /// UpdateForm.
    /// </summary>
    /// <param name="SetSaveRecord">Boolean.</param>
    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    /// <summary>
    /// ClearTotalPurchaseHeader.
    /// </summary>
    procedure ClearTotalPurchaseHeader();
    begin
        Clear(TotalPurchaseHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertExtendedText(var PurchaseLine: Record "Purchase Line")
    begin
    end;

    var
        TransferExtendedText: Codeunit "Transfer Extended Text";
        TotalPurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
        Currency: Record Currency;
        VATAmount: Decimal;
        PurchCalcDiscByType: codeunit "Purch - Calc Disc. By Type";
        DocumentTotals: codeunit "Document Totals";
        TotalAmountStyle: Text;
        RefreshMessageText: text;
        InvDiscAmountEditable: Boolean;
        TotalPurchaseHeader: Record "Purchase Header";
        RefreshMessageEnabled: Boolean;
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";

        ManualUpdateLbl: label 'The totals fields above will not be updated automatically. Learn why, and what to do.';
        ManualUpdateActionLbl: label 'Update the Totals';
        ManualUpdateHelpMsg: label 'To enable fast entry of many document lines, the automatic calculation of the totals will stop after the tenth line.\\To see the totals for more than ten lines, choose Update the Totals.';
        Text001: Label 'You cannot use the Explode BOM function because a prepayment of the purchase order has been invoiced.';

}
