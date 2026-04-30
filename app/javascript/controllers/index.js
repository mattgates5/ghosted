import { application } from "controllers/application"

import CollapsibleController from "controllers/collapsible_controller"
application.register("collapsible", CollapsibleController)

import DismissableController from "controllers/dismissable_controller"
application.register("dismissable", DismissableController)
